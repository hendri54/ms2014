function [h_aV, xs_aV, q_aV] = age_profile(ageV, hhS, priceS, paramS, cS)
% Compute age profile during schooling

h_aV = ha_school_ms(ageV, hhS.hE, hhS.qE, priceS, paramS);

xs_aV = hh_xs_ms(ageV, hhS.hE, hhS.qE, priceS.pS, paramS, cS);

% (q(a) * h(a)) ^ gamma1 from (25)
qhV = hhS.qE .* (hhS.hE ^ paramS.gamma1) .* exp((paramS.r + paramS.deltaH .* (1 - paramS.gamma1)) .* (ageV - 6));

q_aV = qhV ./ (h_aV .^ paramS.gamma1);

F_aV = paramS.zH .* (h_aV .^ paramS.gamma1) .* (xs_aV .^ paramS.gamma2);


%% Self-test

% (13a), inequality
lhsV = priceS.wage .* h_aV;
rhsV = q_aV .* paramS.gamma1 .* F_aV;
assert(all(lhsV < rhsV + 1e-6));

% (23) (same as 13b)
dev13bV = eqn_ms.s_dev13b(h_aV, xs_aV, q_aV, priceS.pS, paramS);
assert(max(abs(dev13bV)) < 1e-4);

end