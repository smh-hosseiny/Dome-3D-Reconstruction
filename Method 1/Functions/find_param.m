function [a, center] = find_param(points)
[~,C] = kmeans(points.', 2);
center = mean(C,1);
d = ones([2,1]);
for i=1:length(d)
    d(i) = norm(center-C(i,:));
end
a = mean(d);
end

