function [im, rep] = find_repeating_pattern(imgq,t)
 
Err = [];
err_min = inf;
for nang = [3 4 5 6]
    imgq2 = imgq(:,[floor(t/nang)+1:end 1:floor(t/nang)],:);
    err = mean(imgq2-imgq, 'all');
    if err < err_min
        err_min = err;
        imgt = imgq;
    end
    Err = [Err;nang err];
end

[~,id] = min(Err(:,2));
rep = Err(id,1);
im = imgt(:,t/2-t/(2*rep):t/2+t/(2*rep),:);


end


