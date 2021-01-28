function [imgq, t, prh, h] = project_patterns(strt, finish,num_of_points,center, normal, y, f,R, Image)
[t1,t2] = find_range(center, normal, y, f, strt, finish);
c = center + t1 * normal;
h = linspace(t1,t2,num_of_points);
h = h - h(1);
prh = polyfit(h,R,7);

th = linspace(pi, 2*pi,1800);
h = linspace(h(1),h(end),600);
l = length(h);
t = length(th);
na = null(normal');
P = [];
for hq = h
    rq = polyval(prh,hq);
    points3d = bsxfun(@plus,c+hq*normal,rq*na*[cos(th); sin(th)]);
    P = [P points3d];
end

K = [f 0 0;0 f 0;0 0 1];
q = K*P;
q = bsxfun(@rdivide, q, q(3,:));
imgq = uint8(zeros(l,t,3));
for i = 1:l
    for j = 1:length(th)
        imgq(i,j,:) = Image(floor(q(2,(i-1)*t+j)),floor(q(1,(i-1)*t+j)),:);
    end
end

s = size(imgq, 2);
shift = floor(s/10);
imgq = imgq(:,shift:end-shift+1,:);
% figure;
% imshow(imgq);
% title('Projected patterns');
end

