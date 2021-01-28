function [im, rep] = find_repeating_pattern(imgq,t)
Err = [];
err_min = inf;
for nang = [4 5 6 7]
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

% % 
% n_slices = [4,5,6,7,8];
% err = inf;
% new_img = [];
% width = size(imgq,2);
% % Er = [];
% for n=1:length(n_slices)
%     n_slice = n_slices(n);
%     rng = linspace(1,width, n_slice+1);
%     for i=1:n_slice
%         imgs = imgq(:, rng(i):rng(i+1),:);
%         ti = repmat(imgs, [1, n_slice]);
%         J = imresize(ti,[size(imgq,1) size(imgq,2)]);
%         d = immse(J,imgq);
% %         mean(J-imgq, 'all');
% %         Er = [Er, d];
% %         if d < 3500
% %             figure; imshow(ti);
% %             d, n_slice
% %         end
%         if d < err
%             new_img = imgs;
%             err = d;
%         end
%         
%     end
% end
% im = new_img;
% rep = ceil(t/size(im,2));


end


