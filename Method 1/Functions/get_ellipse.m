function [x_val, y_val] = get_ellipse(x0,y0,a,b,theta,it)
x_val =[]; y_val=[];
t = it;
    xt = a * cos(t);
    yt = b * sin(t);
    xe = xt * cos(theta) + yt * sin(theta);
    ye = yt * cos(theta) - xt * sin(theta);
    x_val=[x_val, x0 + xe]; y_val= [y_val, y0 + ye];
end

