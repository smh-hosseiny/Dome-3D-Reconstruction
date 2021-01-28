function [xs, ys] = find_symmetry_line(x,y)
[miny,idx] = min(y);
maxy = max(y);
T = min(length(x)-idx, idx)-1;
% left side
x1 = x(idx-T:idx);
y1 = y(idx-T:idx);
%right side
x2 = flip(x(idx:idx+T));
y2 = flip(y(idx:idx+T));

mx = (x1+x2)/2;
my = (y1+y2)/2;
my = double(my); mx = double(mx);
p = polyfit(my, mx, 1);
ys = linspace(miny, maxy, 1000);
xs = polyval(p, ys);

end