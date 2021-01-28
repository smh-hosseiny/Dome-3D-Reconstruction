function run(Image)

addpath('Functions');
nrow = size(Image, 1);

message = 'Choose points on the border of the dome then press enter \nmake sure there is a point on top of dome';
[x, y] = get_input(Image, message);
pause(0.1);
%
fprintf('\ninitializing ...');
tic
close;

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
% plot(x,y,'linewidth',1.5);

[~, ys] = find_symmetry_line(x,y);

[Ix,Iy,FeaturesMatrix] = get_Harris_features(Image,x,y);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


% find angle
fprintf('\nfinding best angle...');
tic
m_range = linspace(-0.05, 0.1, 6);
random = floor(linspace(0.3*length(ys), 0.6*length(ys),3));
slopes = [];
tic
for i=1:length(random)
    dc = ys(random(i));
    best_m = find_m(x,y,dc,m_range,Ix,Iy,FeaturesMatrix,nrow);
    slopes = [slopes, best_m];
end
m = max(slopes);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);



% fit ellipse
fprintf('\nfitting ellipses ...');
tic
for i = floor(floor(max(ys):-1:floor(min(ys))))
    perpendicular_y = m*x + i;
    lpoints = InterX([lx;ly], [x;perpendicular_y]);
    rpoints = InterX([rx;ry], [x;perpendicular_y]);
    if length(lpoints) >= 1 && length(rpoints) >= 1
        ub = i;
        break;
    end
end

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


fprintf('\ninitializing the optimization problem...');
tic
Er = ones(length(pnts2D),1);
F_values = ones(length(pnts2D),1);
num_of_points = 3;
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



fprintf('\nsolving the optimization problem...');
tic
circles = []; 
f = best_f;
for i=1:length(pnts2D)
    [c,n,r] = find_circle_param(pnts2D{i}(1,:), pnts2D{i}(2,:),f);
    circles = [circles, Circle(c,n,r)];
end
for i=1:length(circles)
    circles(i).refine_normal();
end
ref_normal = circles(best_idx).normal;
ref_center = circles(best_idx).center;

[t1,t2] = find_range(ref_center, ref_normal, y, f, strt, finish);
height = linspace(t1,t2,length(circles));
for i = 1:length(circles)
    circles(i).set_normal(ref_normal);
    circles(i).refine_center(ref_center, height(i));
end


num_of_points = 6;
n = ref_normal;
cnt = ref_center;
[profile, ~] = find_profile(cnt,n,x,y,f,strt,finish,num_of_points,nrow);
ref_center = profile(1).center;
figure;
plot_profile(profile,x,y,Ix,Iy,FeaturesMatrix,Image);
title('initial profile');

x0 = [ref_center; ref_normal];
[normal, center] = find_3d_vector(x,y,x0,num_of_points,f,Ix,Iy,FeaturesMatrix,strt,finish,nrow);

e = toc;
fprintf('done! \t Elapsed time: %.2fs \n',e);


% project patterns
fprintf('\nprojecting patterns ...');
tic
strt = 0.01;
finish = find_lower_rng(center,normal,x,y,f,nrow);
num_of_points = 40;
[profile, ~, R] = find_profile(center,normal,x,y,f,strt,finish,num_of_points,nrow);
figure;
plot_profile(profile,x,y,Ix,Iy,FeaturesMatrix,Image);
title('fitted profile');
figure;
plot_profile(profile,x,y,Ix,Iy,FeaturesMatrix,Image,true);
title('fitted profile');


[imgq,t,prh,h] = project_patterns(strt,finish,num_of_points,center,normal,y,f,R,Image);


e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

% reconstructing 3D dome
fprintf('\nreconstructing 3D dome ...');
tic
[im, rep] = find_repeating_pattern(imgq,t);
new_rgb = smooth_image(im);
I = imadjust(new_rgb,[.2 .9],[0, 1]);
plotDome(prh, h, I, rep);
title('3D model');
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);
end

