
function [px, py] = find_ellipse(x,y,perpendicular_y,m,Ix,Iy,FeaturesMatrix,nrow)

points = InterX([x;y], [x;perpendicular_y]);
[a, center] = find_param(points);
x0 = center(1); y0 = center(2);
% plot(x,y); hold on; plot(x,perpendicular_y);
% plot(points(1,:), points(2,:), 'r+');
% plot(x0, y0, 'go');

theta = -atan(m);
[a,b,~] = fit_ellipse(x,y,x0,y0,a,theta,Ix,Iy,FeaturesMatrix,nrow);
% draw(x0,y0,a,b,theta);
[px, py] = get_ellipse(x0,y0,a,b,theta, (0:0.01:2*pi));

end

