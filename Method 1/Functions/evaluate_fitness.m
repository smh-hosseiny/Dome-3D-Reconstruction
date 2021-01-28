function cost = evaluate_fitness(x,y,px,py,nrow)
    [~, i] = min(y);
    xl = x(1:i);
    yl = y(1:i);
    xr = x(i:end);
    yr = y(i:end);

    ymin = min(py);
    ymax = max(py);
    
    left_border = xl((yl >= ymin) & (yl <= ymax));
    left_border_y = yl((yl >= ymin) & (yl <= ymax));
    right_border = xr((yr >= ymin) & (yr <= ymax));
    right_border_y = yr((yr >= ymin) & (yr <= ymax));
    
    left_err = get_err(px,py,left_border,left_border_y,'left');
    right_err = get_err(px,py,right_border,right_border_y,'right');
    cost = left_err + right_err;
    
    if ymin < min(y) || ymax > nrow 
        cost = 1e4;
    end
    
    if isempty(cost)
        cost = 1e5;
    end
        

end

function err = get_err(px,py,x_border,y_border, side)
    err = 0;
    for j=1:length(x_border)
        y_val = int32(y_border(j));
        idx = int32(py) == y_val;
        xx = px(idx);
        if strcmp(side, 'left') == 1
            if sum(xx <= x_border(j)-.5) > 0
                err = err + 1;
            end
            
        elseif strcmp(side, 'right') == 1
            if sum(xx >= x_border(j)+.5) > 0
                err = err + 1;
            end
        end
    end
    if err == 0
        distance = pdist2([px;py].',[x_border;y_border].','minkowski','Smallest',1);
        err = 3 * min(distance,[],'all');
    end

end

