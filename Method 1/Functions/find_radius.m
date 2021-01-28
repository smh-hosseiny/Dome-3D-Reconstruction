function [R, er] = find_radius(x,y,c,n,f,number_of_point, nrow)
R = 0;
er = inf;

c = double(c);
n = double(n);
[~, i] = min(y);
xl = x(1:i);
yl = y(1:i);

r_range = linspace(1, 70, number_of_point);
th = linspace(pi/2,3*pi/2,500);
for i = 1:length(r_range)
    r = r_range(i);
    ci = Circle(c,n,r);
    ci.find_3d_circle(th);
    ci.project2d(f);
    p = ci.pnt2d;
    py = double(p(2,:));
    px = double(p(1,:));
    ymin = min(py);
    ymax = max(py);
    left_border = xl((yl >= ymin) & (yl <= ymax));
    left_border_y = yl((yl >= ymin) & (yl <= ymax));
    
    
    err = 0;
    for j=1:length(left_border)
        y_val = int32(left_border_y(j));
        idx = int32(py) == y_val;
        xx = px(idx);
        if sum(xx <= left_border(j)-.5) > 0
            err = err + 1;
        end
    end
    

    if err == 0
        distance = pdist2([px;py].',[left_border;left_border_y].','minkowski','Smallest',1);
        err = 3 * min(distance,[],'all');
    end
    
    
    if ymax >= nrow || ymin <= min(y)
        err = 1e4;
    end
    
    if err < er
       R = r;
       er = err;
    end
end
