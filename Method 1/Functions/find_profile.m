function [profile, cost, R] = find_profile(center,normal,x,y,f,strt,finish,num_of_points,nrow,len)
if nargin == 9
    len = 500;
end
n = normal;
cnt = center;
profile = {};
[t1,t2] = find_range(cnt, n, y, f, strt, finish);

h = linspace(t1,t2, num_of_points);
R = ones(size(h));
cost = 0;
for i= 1:length(h)
    c = cnt + h(i)* n;
    [r, er] = find_radius(x,y,c,n,f,len,nrow);
    R(i) = r;
    ci = Circle(c,n,r);
    ci.find_3d_circle();
    ci.project2d(f);
    profile = [profile, ci];
    cost = cost + er;
end

end

