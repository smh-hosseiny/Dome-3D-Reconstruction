function best_angle = find_angle(n, Pbase, K, p1, lb, ub, Ix,Iy,FeaturesMatrix, dh)
m = mean([lb, ub]);
indices = floor(linspace(round(2*m/5), round(7*m/5),6));
angle_range = (-1:2:40);
scores = ones(1,length(angle_range));
for idx = indices
    for i=1:length(angle_range)
        ang = angle_range(i);
        na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
        Rna = axang2rotm([n' ang*pi/180]);
        na = Rna*na;
        circle(1).center = Pbase + idx*dh*na;
        circle(1).normal = na;
        j = 0:360;
        a = n;
        b = cross(a,circle(1).normal);
        for r = .01:.001:1
            circle(1).radius = r;
            circle(1).Points = circle(1).center + circle(1).radius*(a*cosd(j)+b*sind(j));
            qcircle = K*[circle(1).Points];
            qcircle = qcircle./repmat(qcircle(3,:),3,1);
            xm = polyval(p1,qcircle(2,:));
            if sum(qcircle(1,:)<xm) > 0
                break;
            end
        end
        score = get_score(qcircle(1,:), qcircle(2,:),Ix,Iy,FeaturesMatrix);
        scores(i) = scores(i) + score;
    end
end
% plot(angle_range, scores);
% xlabel('Angle');
% ylabel('Score');
ang1 = angle_range(scores == max(scores));
ang2 = angle_range(scores == min(scores));
best_angle = max(ang1, ang2);
end

