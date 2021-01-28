function [new_a,new_b,d] = fit_ellipse(x,y,x0,y0,a,theta,Ix,Iy,FeaturesMatrix,nrow)

a_range = linspace(4*a/5, a, 25);
d = inf;

for a_param = a_range
    b0 = a_param/2;
    b_range = linspace(2.5*b0/5, 7.5*b0/5, 40);
    for b_param = b_range
        dist = evaluate(x,y,x0,y0,a_param,b_param,theta,Ix,Iy,FeaturesMatrix,nrow);
        if a_param/b_param < 1.5 || a_param/b_param > 4
            dist = dist + 10;
        end
        if dist <= d
           new_a = a_param; 
           new_b = b_param;
           d = dist;
        end
    end
end
end

