function [a,b] = ellipse_param(param)
A = param(1); B=param(2); C=param(3); D=param(4); E=param(5); F = param(6);
m = -sqrt(2 * (A*E^2 + C*D^2 - B*D*E + (B^2 - 4 *A *C)*F) * (A + C + sqrt((A-C)^2 + B^2))) / (B^2 - 4 * A * C);
n = -sqrt(2 * (A*E^2 + C*D^2 - B*D*E + (B^2 - 4 *A *C)*F) * (A + C - sqrt((A-C)^2 + B^2))) / (B^2 - 4 * A * C);
a = abs(max([m,n]));
b = abs(min([m,n]));

end

