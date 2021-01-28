function [f, error] = find_best_f(x,y,t,px,py,strt,finish,Ix,Iy,FeaturesMatrix,nrow)

fun = @(p) obj_fun(p(1));


f_range = (2000:500:3500);
cost = ones(size(f_range));

for j=1:length(f_range)
    cost(j) =  fun(f_range(j));
end

[error, best_idx] = min(cost);
f = f_range(best_idx);


function [cost] = obj_fun(f)    
    cost = 0;
    [c,n,r] = find_circle_param(px, py, f);
    circle = Circle(c,n,r);
    circle.refine_normal();

    c = circle.center;
    n = circle.normal;
    n = n/norm(n);
    [t1,t2] = find_range(c, n, y, f, strt, finish);
    h = linspace(t1,t2,t);

    
    for i=1:length(h)
        C = c + h(i) * n;
        er = evaluate_fitness(x,y,px,py,nrow);
        err = get_cost(px,py,Ix,Iy,FeaturesMatrix,f);
        cost = cost + er + 0.01 * err;
    end
end

end




function scr = get_cost(px,py,Ix,Iy,FeaturesMatrix,f)
    err = get_score(px,py,Ix,Iy,FeaturesMatrix);
    
    [~,~,~,a,b] = find_circle_param(px,py,f);
    index = a/b;
    s = 0;
    if index < 1.4 
        s = 1e4 * 1.4-index;
    elseif index > 6
        s = 1e4 * (index-6);
    end
    
    scr = err + s;
end

