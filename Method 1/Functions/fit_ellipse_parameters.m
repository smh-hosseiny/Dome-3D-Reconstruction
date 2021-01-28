function [parameters] = fit_ellipse_parameters(x,y)
    A = [ x.^2, x.*y, y.^2, x, y, ones(size(x))];
    [~, ~, v] = svd(A);
    parameters = v(:, end);
end

