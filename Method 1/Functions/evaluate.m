function [distance] = evaluate(x,y,x0,y0,a,b,theta,Ix,Iy,FeaturesMatrix,nrow)

[px, py] = get_ellipse(x0,y0,a,b,theta, linspace(pi/2, 3*pi/2, 250)); 
[~, i] = min(y);
xl = x(1:i);
yl = y(1:i);

ymin = min(py);
ymax = max(py);
left_border = xl((yl >= ymin) & (yl <= ymax));
left_border_y = yl((yl >= ymin) & (yl <= ymax));
err = 0;
for j=1:length(left_border)
    y_val = int32(left_border_y(j));
    idx = int32(py) == y_val;
    xx = px(idx);
    if sum(xx < left_border(j)-.5) > 0
        err = err + 1;
    end
    
end

if err == 0
    distance = pdist2([px;py].',[left_border;left_border_y].','minkowski','Smallest',1);
    err = 3*min(distance,[],'all');
end


distance = err;
if ymax >= nrow || ymin < min(y) 
    distance = 1e4;
end

[px, py] = get_ellipse(x0,y0,a,b,theta, linspace(0, 2*pi, 400));
cost = get_score(px,py,Ix,Iy,FeaturesMatrix);
distance = distance + 0.005 * cost;

if isempty(distance)
    distance = 1e6;
end

end

