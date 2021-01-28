function [center3d, normal,r,a,b] = find_circle_param(x,y,f)
x = x(:); y = y(:);
param = fit_ellipse_parameters(x,y);
[a,b] = ellipse_param(param);
[LMN, T1, EigenValues ] = LMN_calculator(param, f);
[center3d, normal, r] = get_3d_circle(LMN, T1, EigenValues,a);
end

