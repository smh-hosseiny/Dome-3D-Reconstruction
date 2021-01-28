function [lb] = find_lower_rng(cnt,n,x,y,f,nrow)

[t1,t2] = find_range(cnt, n, y, f, .8, .99);
h = linspace(t1,t2, 6);
for i = 1:length(h)
    c = cnt + h(i)* n;
    [r, ~] = find_radius(x,y,c,n,f,450,nrow);
    ci = Circle(c,n,r);
    ci.find_3d_circle();
    ci.project2d(f);
    pnts = ci.pnt2d;
    if max(pnts(2,:)) > nrow
        idx = i-1;
        break;
    end
    idx = i;
end
    
lb = linspace(.8,.99,6);
lb = lb(idx);
end

