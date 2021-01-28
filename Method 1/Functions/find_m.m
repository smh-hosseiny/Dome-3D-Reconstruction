function [best_theta] = find_m(x,y,dc,m_range,Ix,Iy,FeaturesMatrix,nrow)
ds = [];
for m = m_range
    theta = -atan(m);
    perpendicular_y = m*x + dc;
    points = InterX([x;y], [x;perpendicular_y]);
    [a, center] = find_param(points);
    x0 = center(1); y0 = center(2);
    [~,~,d] = fit_ellipse(x,y,x0,y0,a,theta,Ix,Iy,FeaturesMatrix,nrow);
    ds = [ds, d];  
end
[~, i] = min(ds);
best_theta = m_range(i);

end

