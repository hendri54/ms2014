function devV = s_dev13b(nh_aV, x_aV, q_aV, pS, paramS)

lhsV = pS .* x_aV;
rhsV = q_aV .* paramS.gamma2 .* paramS.zH .* (nh_aV .^ paramS.gamma1) .* (x_aV .^ paramS.gamma2);
devV = lhsV - rhsV;
validateattributes(devV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

end