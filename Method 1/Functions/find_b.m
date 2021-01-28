function b = find_b(point,x0,y0,a,theta)
xx = point(1); yy = point(2);
A = ((xx-x0)*cos(theta)+(yy-y0)*sin(theta))^2;
B = ((xx-x0)*sin(theta)-(yy-y0)*cos(theta))^2;
b = abs(sqrt(abs(B/(1-A/(a^2)))));

end

