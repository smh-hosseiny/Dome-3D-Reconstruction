function run(Image)

addpath('Functions');
nrow = size(Image, 1);
ncol = size(Image, 2);

message = 'Choose points on the border of the dome then press enter \nmake sure there is a point on top of dome';
[xCoordinates, yCoordinates] = get_input(Image, message);
pause(0.25);
%
fprintf('\ninitializing ...');
tic
f = 500;
cx = ncol/2+10;
cy = nrow/2-10;
K = [f 0 cx;0 f cy;0 0 1];
dh = 0.01;
%
% imshow(Image);
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
MaxIdx = max(Iy);
%
[~,~,n,Pbase] = find_symmetric_line(ly,ry,p1,p2,K);
plot(x,y,'r','linewidth',1);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


% find angle
fprintf('\nfinding best angle...');
tic
[lb, ub] = get_range(n, 0, yCoordinates, Pbase, K, p1, nrow, dh, MaxIdx);
best_angle = find_angle(n, Pbase, K, p1, lb, ub, Ix,Iy,FeaturesMatrix, dh);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


%fit ellipse
fprintf('\nfitting ellipses ...');
tic
[lb, ub] = get_range(n, best_angle, yCoordinates, Pbase, K, p1, nrow, dh);
[profile,na,a,b] = fit_profile(n, best_angle, Pbase, K, p1, lb, ub, Image, dh);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

% project patterns
fprintf('\nprojecting patterns ...');
tic
[imgq,t] = project_patterns(lb,ub,dh,ncol,profile,Pbase,na,a,b,Image,K,xCoordinates);

s = size(imgq, 2);
shift = floor(s/10);
imgq = imgq(:,shift:end-shift+1,:);


e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

% reconstructing 3D dome
fprintf('\nreconstructing 3D dome ...');
tic
[im, rep] = find_repeating_pattern(imgq,t);
new_rgb = smooth_image(im);
I = imadjust(new_rgb,[.2 .9],[0, 1]);
plotDome(lb, ub, profile, dh, I, rep);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);
end

