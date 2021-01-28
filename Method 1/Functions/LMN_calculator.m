function [ LMN, T1, EigenValues ] = LMN_calculator(parameters, f )
    % Calculates L, M, N, and T1 respect to parameters.
    a = parameters(1);%x^2
    b = parameters(2);%xy
    c = parameters(3);%y^2
    d = parameters(4);%x
    e = parameters(5);%y
    g = parameters(6);%cte
    b = b/2;
    d = d/2;
    e = e/2;
    Q = [a*f^2, b*f^2, d*f; b*f^2, c*f^2, e*f; d*f, e*f, g];
    [V, D] = eig (Q);
    T1  = V;
    l1 = D(1,1);
    l2 = D(2,2);
    l3 = D(3,3);
    EigenValues = [l1, l2, l3]';
    syms L M N real
    equations = [(L^2 + M^2 + N^2) == 1, ((l1 * M^2) / (L^2 + M^2) + (l2 * L^2) / (L^2 + M^2)) == ((l1 * L^2 * N^2) / (L^2 + M^2) + (l2 * M^2 * N^2) / (L^2 + M^2) + l3 * (L^2 + M^2)), (((2 * L * M * N * (l1 - l2)) / (L^2 + M^2)) == 0)];
    S = solve (equations, [L, M, N]);
    L = double (S.L);
    M = double (S.M);
    N = double (S.N);
    LMN = [L, M, N].';
end

