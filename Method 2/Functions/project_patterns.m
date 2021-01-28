function [imgq, t] = project_patterns(lb,ub,dh,ncol,profile,Pbase,na,a,b,Image,K,xCoordinates)
h = lb*dh:dh/10:ub*dh;
l = length(h);
th = floor(180 * min(xCoordinates)/ncol):0.1:ceil(180 * max(xCoordinates)/ncol);
t = length(th);
P = [];
for hq = h
    rq = polyval(profile,hq);
    P = [P (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)))];
end
q = K*P;
q = bsxfun(@rdivide, q, q(3,:));
imgq = uint8(zeros(l,t,3));
for i = 1:l
    for j = 1:length(th)
        imgq(i,j,:) = Image(floor(q(2,(i-1)*t+j)),floor(q(1,(i-1)*t+j)),:);
    end
end

end

