function xsV = hh_xs_ms(ageV, hE, qE, pS, paramS, cS)
% xs(a) from (21)

% replace with spsS +++++

c1 = (hE ^ paramS.gamma1) .* qE ./ pS .* paramS.gamma2 .* paramS.zH;

c2 = exp(paramS.g_xs .* (ageV - cS.demogS.startAge));

xsV = c1 .^ (1 / (1 - paramS.gamma2)) .* c2;
validateattributes(xsV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, 'size', size(ageV)})


end