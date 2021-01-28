function [t1,t2] = find_range(center, normal, y, f, lower_b, upper_b)
    syms ts;
    d3Point = center + ts * normal;
    K = [f, 0, 0; 0, f, 0; 0, 0, 1];
    q = K * d3Point;
    p2d = q(1 : 2, :) ./ q(3, :);
    y2d = p2d(2);
    range = max(y) - min(y);
    t2 = mean(double(solve(vpa(y2d) -  (min(y) + upper_b*range), ts)));
    t1 = mean(double(solve(vpa(y2d) - (min(y) + lower_b*range), ts)));

end

