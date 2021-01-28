function [c,n,radius] = get_3d_circle(LMN, T1, EigenValues,p)
    NumOfLMN = size(LMN, 2);
    c = {}; n = {}; radius = {};
    for j = 1 : NumOfLMN
        n1 = LMN(:, j);
        [centerr, r, normal] = NormalCenterCalculator(T1,n1,EigenValues,p);
        if r~=0
            c = [c; centerr];
            n = [n; normal];
            radius = [radius; r];
        end
    end

end

