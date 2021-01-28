function [prh, na, a, b] = fit_profile(n, ang, Pbase, K, p1, lb, ub, Image, dh)
figure;
imshow(Image);
hold on;
na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;
len = ub - lb;
rh = zeros(1, len);
h = zeros(1, len);
range = (lb:ub);

for i = lb:ub
    circle(i).center = Pbase + (i-1)*dh*na;
    circle(i).normal = na;
    j = 0:360;
    a = n;
    b = cross(a,na);
    for r = .01:.001:.9
        circle(i).radius = r;
        circle(i).Points = circle(i).center + circle(i).radius*(a*cosd(j)+b*sind(j));
        qcircle = K*[circle(i).Points];
        qcircle = qcircle./repmat(qcircle(3,:),3,1);
        xm = polyval(p1,qcircle(2,:));
        if sum(qcircle(1,:)<xm) > 0
            break;
        end
    end
    h(i) = i*dh;
    rh(i) = r;
    plot(qcircle(1,:), qcircle(2,:),'g', 'linewidth',0.5);
    drawnow
end
title('Profile');
prh = polyfit(h,rh,7);
% ref_center = circle(lb).center;
end

