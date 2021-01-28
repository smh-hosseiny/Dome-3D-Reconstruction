function [center, r, normal] = NormalCenterCalculator(T1, n1, eigen_values, p)
    % Computes center, radius, and normal vector of a circle with a scale.
%     p = 2;
    l1 = eigen_values(1);
    l2 = eigen_values(2);
    l3 = eigen_values(3);
    L = n1(1);
    M = n1(2);
    N = n1(3);
    
    T2 = [((-M) / sqrt(L^2 + M^2)), ((-L*N) / sqrt(L^2 + M^2)), L;
        (L) / sqrt(L^2 + M^2), (-M*N) / sqrt(L^2 + M^2), M;
        0, sqrt(L^2 + M^2), N];
    D = ((2 * p * L * M *(l2-l1)) / (sqrt(L^2 + M^2)));
    A = ((l1 * M^2) / (L^2 + M^2) + (l2 * L^2) / (L^2 + M^2));
    E = ((2*p*N) / (sqrt(L^2 + M^2))) * (-l1 * L^2 - l2 * M^2 + l3 * (L^2 + M^2));
    F = (p^2) * (l1 * L^2 + l2 * M^2 + l3 * N^2);
    center_x = (-D) / (2*A);
    center_y = (-E) / (2*A);
    center_z = p;
    center3 = [center_x; center_y; center_z];
    center2 = T2 * center3;
    center1 = T1 * center2;
    if center1(3) < 0
        center = 0;
        r = 0;
        normal = [0; 0; 0];
        return
    end
    radius = sqrt((((D^2) / (4*(A^2))) + ((E^2) / (4*(A^2))) - F / A));
    normal_vector = T1 * [L, M, N]';
    
    center = center1;
    r = radius;
    normal = normal_vector;
end
