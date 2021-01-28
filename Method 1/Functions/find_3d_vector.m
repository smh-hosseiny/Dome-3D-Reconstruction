function [normal, center] = find_3d_vector(x,y,x0,t,f,Ix,Iy,FeaturesMatrix,strt,finish,nrow)
A = [0,0,0,0,-1,0; 0,0,0,0,-1,1];
b = [0; 0];
Aeq = [];
beq = [];
lb = [-20,-20,0,-1,-1,-1];
ub = [100,100,600,1,1,1];
nonlcon = [];

fun = @(p) obj_fun(p(1), p(2), p(3), p(4), p(5), p(6));

options = optimoptions('patternsearch','MaxIter', 9,'MeshTolerance',1e-3,...
'PlotFcn','psplotbestf','ScaleMesh',true,'MeshAccelerator','on');

[param,~] = patternsearch(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);



normal = param(4:6);
center = param(1:3);

function cost = obj_fun(c1, c2, c3, n1, n2, n3)
    n = [n1;n2;n3];
    n = n/norm(n);
    cnt = [c1;c2;c3];
    same_pattern_score = ones(t,1);
    fitness_score = ones(t,1);
    [profile, ~] = find_profile(cnt,n,x,y,f,strt,finish,t,nrow,400);
        
    for i= 1:length(profile) 
        p = profile(i).pnt2d;
        px = double(p(1,:)); py = double(p(2,:));
        same_pattern_score(i) = get_cost(px,py,Ix,Iy,FeaturesMatrix,f);
        fitness_score(i) = evaluate_fitness(x,y,px,py,nrow);
    end
    same_pattern_cost = sum(same_pattern_score);
    fitness_cost = sum(fitness_score);
    cost = 0.01 * same_pattern_cost + fitness_cost;
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
