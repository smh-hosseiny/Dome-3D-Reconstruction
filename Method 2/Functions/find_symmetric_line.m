function [x,y,n,Pbase] = find_symmetric_line(ly,ry,p1,p2,K)
options = optimoptions('fmincon');
options.Display = 'off';
kmin = round(min(min(ly), min(ry)));
kmax = round(max(max(ly), max(ry)));
d = kmax - kmin;
k1 = kmin + 0.01*d;
k2 = kmin + 0.99*d;
x = fmincon(@(x) normalCost(x,p1,p2,k1,k2,K),[0 pi/2],[],[],[],[],[-pi/2 -pi],[pi/2 pi],[],options);
n = [cos(x(1))*sin(x(2));sin(x(1));cos(x(1))*cos(x(2))];
n = n/norm(n);
N = 40;
idx = linspace(k1,k2,N);
qsa = zeros(2,N);
k = 0;

for i = idx
    k = k + 1;
    ps = [polyval(p1,i);i];
%     plot(ps(1),ps(2),'g.')
    Ps = K\[ps;1];
    Qs = Ps-2*Ps'*n*n;
    qs = K*Qs./Qs(3,:);
%     plot(qs(1),qs(2),'r.')
    Qs = Ps-Ps'*n*n;
    qs = K*Qs./Qs(3,:);
%     plot(qs(1),qs(2),'m.');
    qsa(:,k) = qs(1:2);
end
pa = polyfit(qsa(2,:),qsa(1,:),1);
y = [k1 k2];
x = polyval(pa,y);
% plot(x,y,'r','linewidth',1);
% title('symmetric line');
Pbase = K\[x(2);y(2);1];
end

