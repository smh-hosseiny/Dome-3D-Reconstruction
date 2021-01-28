%% get input
clc; clear; close all; 

addpath('Functions');
fullFileName = 'E:\ALL(2) !\پروژه کارشناسی\gonbad3.jpg';
Image = imread(fullFileName);
message = 'Identify points on borders of the dome then press enter \nmake sure there is a point on top of dome';
[x,y] = get_input(fullFileName, message);
% xy = cat(2,[x;y]);
% save('border','xy');

%%
close all; clear; clc

cd 'E:\ALL(2) !\پروژه کارشناسی'
fullFileName = 'E:\ALL(2) !\پروژه کارشناسی\gonbad3.jpg';

Image = imread(fullFileName);
% Image = imresize(Image,[468 412]);
%%
addpath('Functions');

message = 'Identify points on borders of the dome then press enter \nmake sure there is a point on top of dome';
[x,y] = get_input(Image, message);
%%
nrow = size(Image, 1);
ncol = size(Image, 2);
load('border');
x = double(xy(1,:)); 
y = double(xy(2,:));
%%

imshow(Image);
hold on;
[~,i] = min(y);
lx = x(1:i); ly = y(1:i);
rx = x(i:end); ry = y(i:end);
warning off
p1 = polyfit(ly,lx,7);
p2 = polyfit(ry,rx,7);
lx = polyval(p1,ly);
rx = polyval(p2,ry);
x = [lx, rx];
y = [ly, ry];
plot(x,y,'r','linewidth',1.5);

%% find symmetry line
imshow(Image);
hold on;
plot(x, y, 'r', 'LineWidth', 2);
[xs, ys] = find_symmetry_line(x,y);
plot(xs, ys,'LineWidth', 2);
coeffs = polyfit(xs, ys, 1);
dc = ys(floor(0.5*length(ys)));
m = -1/coeffs(1);
perpendicular_y = m*x + dc;
plot(x, perpendicular_y,'LineWidth', 2);
% impixelinfo();
%% find Harris Features
[Ix,Iy,FeaturesMatrix] = get_Harris_features(Image,x,y);

%% find best slope
fprintf('\nfinding best angle...');
m_range = linspace(-0.05, 0.1, 6);
random = floor(linspace(0.3*length(ys), 0.7*length(ys),3));
slopes = [];
tic
for i=1:length(random)
    dc = ys(random(i));
%     plot(x,m*x+dc, 'linewidth',2);
    best_m = find_m(x,y,dc,m_range,Ix,Iy,FeaturesMatrix,nrow);
    slopes = [slopes, best_m];
end
m = max(slopes);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

%% fit ellipse
% clc;
fprintf('\nfitting elipses...');
tic

for i = floor(floor(max(ys):-1:floor(min(ys))))
    perpendicular_y = m*x + i;
    lpoints = InterX([lx;ly], [x;perpendicular_y]);
    rpoints = InterX([rx;ry], [x;perpendicular_y]);
    if length(lpoints) >= 1 && length(rpoints) >= 1
        ub = i-2;
        break;
    end
end

imshow(Image);hold on;axis equal;
plot(x,y,'LineWidth',2, 'color','r');
plot(xs,ys,'LineWidth',1)
range = max(ys) - min(ys);
pnts2D = {};
l_rng = min(ys) + 0.1*range;
u_rng = ub - 0.1*range;

for i = floor(linspace(l_rng, u_rng, 6))
    perpendicular_y = m*x + i;
    [px,py] = find_ellipse(x,y,perpendicular_y,m,Ix,Iy,FeaturesMatrix,nrow);
    xy = cat(2,[px;py]);
    pnts2D = [pnts2D,xy];
end
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);
%%


% save('2Dpoints', 'pnts2D');
% save('Heights', 'heights')
%% 
%**************************************************************************
% PHASE 2
%**************************************************************************
%% load 2D points
clc;
load('2Dpoints');
pnts2D = flip(pnts2D);
xsize = size(Image,2);
ysize = size(Image,1);

%%

imshow(Image);
hold on;
plot(x, y, 'linewidth', 2, 'color', 'r');
% y = 467-y; ys=467-ys;
for i=1:length(pnts2D)
    plot(pnts2D{i}(1,:), pnts2D{i}(2,:), 'color', 'y', 'linewidth', 1);
    get_score(pnts2D{i}(1,:), pnts2D{i}(2,:), Ix,Iy,FeaturesMatrix)
end


%% find best f
fprintf('\ninitializing the optimization problem...');
tic
Er = ones(length(pnts2D),1);
F_values = ones(length(pnts2D),1);
num_of_points = 4;
strt = 0.1;
finish = 0.85;
for i = 1:length(pnts2D)
    px = pnts2D{i}(1,:);
    py = pnts2D{i}(2,:);
    [f_val,function_val] = find_best_f(x,y,num_of_points,px,py,strt,finish,Ix,Iy,FeaturesMatrix,nrow);
    Er(i) = function_val;
    F_values(i) = f_val;
end
[~,best_idx] = min(Er);
best_f = F_values(best_idx);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);
%%
save('best_f', 'best_f');
save('best_idx', 'best_idx');

%% Initialize Circles
% load('best_f');
% load('best_idx');

% best_f = 3500;
% best_idx = 3;

circles = []; clc;
f = best_f;
for i=1:length(pnts2D)
    [c,n,r] = find_circle_param(pnts2D{i}(1,:), pnts2D{i}(2,:),f);
    circles = [circles, Circle(c,n,r)];
end

%% refine parameters
for i=1:length(circles)
    circles(i).refine_normal();
end
%%
ref_normal = circles(best_idx).normal;
ref_center = circles(best_idx).center;

[t1,t2] = find_range(ref_center, ref_normal, y, f, 0.1, 0.85);
height = linspace(t1,t2,length(circles));
for i = 1:length(circles)
    circles(i).set_normal(ref_normal);
    circles(i).refine_center(ref_center, height(i));
end
ref_center = circles(1).center;
%%
hold on; grid on; axis equal;
for i= 1:length(circles) 
    circles(i).find_3d_circle();
    circles(i).plot3d();
    circles(i).project2d(f);
    circles(i).plot2d();
end

plot(x,y);
plot(xs,ys);
camproj('perspective');

%% initialize profile
tic
clc;
strt = 0.1;
% finish = 0.99;
num_of_points = 6;
n = ref_normal;
cnt = ref_center;
finish = find_lower_rng(cnt,n,x,y,f,nrow);
[profile, fitness_cost] = find_profile(cnt,n,x,y,f,strt,finish,num_of_points,nrow);
ref_center = profile(1).center;
toc

same_patter_following_cost = plot_profile(profile,x,y,Ix,Iy,FeaturesMatrix,Image);

%% solve optimization problem

fprintf('\nsolving the optimization problem...');

tic
x0 = [ref_center; ref_normal];
[normal, center] = find_3d_vector(x,y,x0,num_of_points,f,Ix,Iy,FeaturesMatrix,strt,finish,nrow);

e = toc;
fprintf('done! \t Elapsed time: %.2fs \n',e);
%%
[profile, fitness_cost] = find_profile(center,normal,x,y,f,strt,finish,num_of_points,nrow);
same_patter_following_cost = plot_profile(profile,x,y,Ix,Iy,FeaturesMatrix,Image);
title('fitted profile');
%%
imshow(Image); hold on;
c1 = 0;
c2 = 0;
for i =1:length(profile)
   p = profile(i).pnt2d;
   px = p(1,:); py = p(2,:);
   plot(px,py);
   c1 = c1+evaluate_fitness(x,y,px,py,nrow);
   c2 = c2+get_score(px,py,Ix,Iy,FeaturesMatrix);
end
%%
save('normal', 'normal');
save('center', 'center');
%% load result
load('normal2')
load('center2')
load('best_f')
load('best_idx')
f = best_f;

%% plot result
tic
strt = 0.01;
finish = 0.9;
num_of_points = 40;
[profile, fitness_cost, R] = find_profile(center,normal,x,y,f,strt,finish,num_of_points,nrow);
toc
%%
figure;
plot_profile(profile,x,y,Ix,Iy,FeaturesMatrix,Image);
title('fitted profile');
figure;
plot_profile(profile,x,y,Ix,Iy,FeaturesMatrix,Image,true);
title('fitted profile');

%%
[imgq, t, prh, h] = project_patterns(strt, finish,num_of_points,center, normal,y,f,R, Image);


%%
% reconstructing 3D dome
fprintf('\nreconstructing 3D dome ...');
tic
[im, rep] = find_repeating_pattern(imgq,t);
imshow(im);
%%
new_rgb = smooth_image(im);
I = imadjust(new_rgb,[0.3 .9],[]);
plotDome(prh, h, I, rep);
title('3D model');
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

%%
new_rgb = smooth_image(im);
I = imadjust(new_rgb,[.2 .9],[0, 1]);
figure;
combImg = imfuse(new_rgb, im, 'montage');
imshow(combImg);
%%
blender = vision.AlphaBlender('Operation','Blend');
J = blender(im,new_rgb);
figure; imshow(J);
%%
co = imfuse(I,I, 'montage');
imshow(co);
%%
s = 150;
I2 = im(:,1:s,:);
lab2 = rgb2lab(I2); l2 = lab2(:,:,1);
I1 = im(:,end-s+1:end,:);
lab1 = rgb2lab(I2); l1 = lab1(:,:,1);

m1 = mean(l1,1); m2 = mean(l2,1);
plot(1:2*length(m1), [m1,m2]);
xlabel('number of column');
title('L value');
d = mean(m2(1:10)) - m1(100:150);
m1(100:150) = m1(100:150) + linspace(0,1,51).*d;
nl1 = repmat(m1,[size(l1,1),1]);
lab1(:,:,1) = nl1;
I1 = lab2rgb(lab1);
%%
s = 200;
I2 = im(:,1:s,:);
I1 = im(:,end-s+1:end,:);
I1 = cat(2,I1,I2(:,1:50,:));
I2 = cat(2,I1(:,end-100+1:end-50,:),I2);




