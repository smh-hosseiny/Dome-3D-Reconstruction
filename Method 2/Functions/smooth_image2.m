function new_rgb = smooth_image2(im)  

ch = ['L', 'a', 'b'];
r = floor(size(im,2)/3);
lab = rgb2lab(im);
for c =1:length(ch)
    v = {};
    channel = lab(:,:,c);
    v{1} = channel(:,end-r+1:end);
    v{2} = channel(:,1:r);
    v{3} = channel(:, r+1:end-r);
%     len = length(channel(:));

    Pd = fitdist(v{3}(:),'Normal');
%     x_values = linspace(min(channel,[],'all'), max(channel,[],'all'), len);
    mu = Pd.mu;
    sigma = Pd.sigma;
%     subplot(1,3,c);
%     plot(x_values,pdf(Pd,x_values),'LineWidth',1);
%     hold on; grid on;
    
    for i=1:3
        data = v{i};
        pd = fitdist(data(:),'Normal');
%         x_values = linspace(min(data,[],'all'), max(data,[],'all'), len);
%         y = pdf(pd,x_values);
%         plot(x_values,y,'LineWidth',1);
        v{i} = v{i} - pd.mu;
        v{i} = v{i}/pd.sigma;
        v{i} = v{i} * sigma;
        v{i} = v{i} + mu;
        
%         rng = 1:size(v{i},2);
        ss = 5;
        if i == 1
%             f = flip(exp(rng/1000));
%             ff = repmat(f,size(v{i},1),1);
%             v{i} = v{i} .* ff;
            if c == 1
                aim = v{i}(:,1);
                s = v{3}(:,end-ss+1);
                x = linspace(0,1,ss);
                A = s + x.*(aim - s);
                v{3}(:,end-ss+1:end) = A;
            end
        elseif i == 2
%             f = exp(-rng/800);
%             ff = repmat(f,size(v{i},1),1);
%             v{i} = v{i} .* ff;
            if c == 1
                s = v{i}(:,end);
                aim = v{3}(:,ss);
                x = linspace(0,1,ss);
                A = s + x.*(aim - s);
                v{3}(:,1:ss) = A;
            end
            
        end
                
    end
    
    if c==1
        ss = 7;
        aim = v{2}(:,ss);
        s = v{1}(:,end -ss +1);
        x = linspace(0,1,2*ss);
        A = s + x.*(aim - s);
        v{1}(:,end - ss+1:end) = A(:,1:ss);
        v{2}(:,1:ss) = A(:,ss+1:end);
    end
    
    
%     title(ch(c));
%     legend('mean','right','left');
    channel(:,end-r+1:end) = v{1};
    channel(:,r+1:end-r) =  v{3};
    channel(:,1:r) = v{2};
    lab(:,:,c) = channel;
end

    new_rgb = lab2rgb(lab);
    new_rgb = rescale(new_rgb, 0, 255);
    new_rgb = uint8(new_rgb);
    
    
    
    img = new_rgb;
    lab = rgb2lab(img);
    [l,a,b] = imsplit(lab);
    
    p = fitdist(l(:),'Normal');
%     l(l < p.mu-2*p.sigma) = p.mu-2*p.sigma;
%     l(l > p.mu+2*p.sigma) = p.mu+2*p.sigma;
    l = rescale(l, p.mu-1*p.sigma, p.mu+1*p.sigma);
    l = reshape(l, size(a));           
    new_hsv = cat(3,l,a,b);
    new_rgb = lab2rgb(new_hsv);
    new_rgb = rescale(new_rgb, min(img,[],'all'), max(img,[],'all'));
    new_rgb = uint8(new_rgb);
    
end