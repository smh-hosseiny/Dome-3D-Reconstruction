close all
clear
clc
cd 'E:\ALL(2) !\پروژه کارشناسی'
fullFileName = 'E:\ALL(2) !\پروژه کارشناسی\gonbad3.jpg';

Image = imread(fullFileName);
nrow = size(Image, 1);
ncol = size(Image, 2);
%%
addpath('Functions');
message = 'Choose points on borders of the dome then press enter \nmake sure there is a point on top of dome';
[xCoordinates, yCoordinates] = get_input(Image, message);
%%
load('border');
xCoordinates = double(xy(1,:)); 
yCoordinates = double(xy(2,:));

%%
fprintf('\ninitializing ...');
tic
f = 500;
cx = ncol/2+10;
cy = nrow/2-10;
K = [f 0 cx;0 f cy;0 0 1];
dh = 0.01;
%
imshow(Image);
hold on;
[~,i] = min(yCoordinates);
lx = xCoordinates(1:i); ly = yCoordinates(1:i);
rx = xCoordinates(i:end); ry = yCoordinates(i:end);
warning off
p1 = polyfit(ly,lx,7);
plot(polyval(p1,ly),ly,'r','linewidth',1)
p2 = polyfit(ry,rx,7);
plot(polyval(p2,ry),ry,'r','linewidth',1)

x = [polyval(p1,ly), polyval(p2,ry)];
y = [ly, ry];
%
[Ix,Iy,FeaturesMatrix] = get_Harris_features(Image,x,y);
plot(Ix,Iy,'r.');
%
[~,~,n,Pbase] = find_symmetric_line(ly,ry,p1,p2,K);
plot(x,y,'linewidth',1);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


%% find angle
fprintf('\nfinding best angle...');
tic
[lb, ub] = get_range(n, 0, yCoordinates, Pbase, K, p1, nrow, dh, max(Iy));
best_angle = find_angle(n, Pbase, K, p1, lb, ub, Ix,Iy,FeaturesMatrix, dh);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


%% fit ellipse
fprintf('\nfitting ellipses ...');
tic
[lb, ub] = get_range(n, best_angle, yCoordinates, Pbase, K, p1, nrow, dh,max(Iy));
[profile,na,a,b] = fit_profile(n, best_angle, Pbase, K, p1, lb, ub, Image, dh);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

%% project patterns
fprintf('\nprojecting patterns ...');
tic
[imgq,t] = project_patterns(lb,ub,dh,ncol,profile,Pbase,na,a,b,Image,K,xCoordinates);
figure
s = size(imgq, 2);
shift = floor(s/7);
imgq = imgq(:,shift:end-shift,:);
imshow(imgq);
title('Projected patterns');

e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

%% reconstructing 3D dome
fprintf('\nreconstructing 3D dome ...');
tic
[im, rep] = find_repeating_pattern(imgq,t);
new_rgb = smooth_image(im);
I = imadjust(new_rgb,[.3 .3 .3; .9 .9 .9],[]);
plotDome(lb, ub, profile, dh, I, rep);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);
%%
C = imfuse(new_rgb, im,'blend');
imshow(C);
plotDome(lb, ub, profile, dh, C, rep);
%%
figure;
new_rgb = im;
II = uint8(zeros(size(new_rgb,1), 2*size(new_rgb,2), size(new_rgb,3)));
II(:,1:size(new_rgb,2),:) = new_rgb;
II(:,size(new_rgb,2)+1:end,:) = new_rgb;
imshow(II);
%%
GUI

%%
function GUI
image = imread('card.jpg');
f = figure('Visible','off','Position',[360,500,400,300]);
ha = axes('unit', 'normalized', 'position', [0 0 1 1]);
imagesc(image);
% Construct the components.
h1 = uicontrol('Style','pushbutton','String','Path to image',...
           'Position',[0,220,70,25], 'Callback',{@Pathbutton_Callback});
h2  = uicontrol('Style','text','String','Choose Method',...
           'Position',[315,170,100,15]);
       
h3 = uicontrol('Style','popupmenu',...
           'String',{'Method 1','Method 2'},...
           'Position',[300,140,100,25],'Callback',{@popup_menu_Callback});
       
h4 = uicontrol('Style','pushbutton','String','Run',...
           'Position',[315,90,70,25],'Callback',{@Runbutton_Callback});
 


align([h1,h2,h3,h4],'Center','None');

f.Units = 'normalized';
h1.Units = 'normalized';
h2.Units = 'normalized';
h3.Units = 'normalized';
h4.Units = 'normalized';
f.Name = 'GUI';
movegui(f,'center')
f.Visible = 'on';
end

 function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = source.String;
      val = source.Value;
      % Set current data to the selected data set.
      switch str{val}
      case 'Method 1' % User selects Peaks.
         addpath('E:\ALL(2) !\پروژه کارشناسی\Method 2');
      case 'Method 2' % User selects Membrane.
         addpath('E:\ALL(2) !\پروژه کارشناسی\Method 1');
      end
 end

function Pathbutton_Callback(source,eventdata) 
global Image_of_dome;
[file,path] = uigetfile('*.png; *.jpg',...
               'Select an image');
selectedfile = fullfile(path,file);
Image_of_dome = imread(selectedfile);
end

function Runbutton_Callback(source,eventdata) 
    global Image_of_dome;
    run(Image_of_dome);
end


