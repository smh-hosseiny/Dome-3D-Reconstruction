function [lb, ub] = get_range(n, ang, y, Pbase, K, p1, nrow, dh, minf)

na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;
Min = min(y);
Max  = max(y);
if nargin == 8
    M = mean([nrow, Max]);
else
    M = minf;
end
lb = []; ub = [];
for i = 1:1:100
    circle(i).center = Pbase + (i-1)*dh*na;
    circle(i).normal = na;
    j = 0:360;
    a = n;
    b = cross(a,circle(1).normal);
    for r = .01:.001:1
        circle(i).radius = r;
        circle(i).Points = circle(i).center + circle(i).radius*(a*cosd(j)+b*sind(j));
        qcircle = K*[circle(i).Points];
        qcircle = qcircle./repmat(qcircle(3,:),3,1);
        xm = polyval(p1,qcircle(2,:));
        if sum(qcircle(1,:)<xm) > 0
            break;
        end
    end
    if floor(.97*Min) <= min(qcircle(2,:)) && min(qcircle(2,:)) <= round(1.2 * Min)
        ub = [ub, i];
    end    
    if Max <= max(qcircle(2,:)) && max(qcircle(2,:)) < nrow ...
         &&  max(qcircle(2,:)) <= M
        lb = [lb, i];
    end    
end
lb = min(lb);
ub = max(ub);

end

