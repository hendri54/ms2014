function school_solve_test_ms(setNo)

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);
ageRetire = cS.demogS.Rmax;

% Factor prices
TFP = 1;
pk = 1;
priceS = factor_prices_ms(TFP, pk, cS);

[hhS.hE, hhS.hS, hhS.s, hhS.qE, hhS.xE] = school_solve_ms(priceS, paramS, ageRetire, setNo);

nAge = 100;
ageV = linspace(6, 6 + hhS.s, nAge);
[h_aV, xs_aV, q_aV] = school_ms.age_profile(ageV, hhS, priceS, paramS, cS);

F_aV = paramS.zH .* (h_aV .^ paramS.gamma1) .* (xs_aV .^ paramS.gamma2);

% dAge = 1e-3;
% [h2_aV, xs2_aV, q2_aV] = school_ms.age_profile(ageV(1 : (nAge-1)) + dAge, hhS, priceS, paramS, cS);

hDotV = diff(h_aV) ./ diff(ageV);
qDotV = diff(q_aV) ./ diff(ageV);


%% Check first-order conditions

bpS = BenPorathContTimeLH(paramS.zH, paramS.deltaH, paramS.gamma1, paramS.gamma2, ageRetire - hhS.s - 6, hhS.hS, ...
   priceS.pW, paramS.r, priceS.wage);


% (13a) and (13b) are tested in age_profile.m

% (13c)
rhsV = q_aV .* (paramS.r - F_aV ./ h_aV .* paramS.gamma1 + paramS.deltaH);
checkLH.approx_equal(qDotV, 0.5 .* (rhsV(1 : (nAge-1)) + rhsV(2:nAge)), 1e-3, []);

% (13d)
rhsV = F_aV - paramS.deltaH .* h_aV;
checkLH.approx_equal(hDotV, 0.5 .* (rhsV(1 : (nAge-1)) + rhsV(2:nAge)), 1e-3, []);

% qE = q(6)
checkLH.approx_equal(hhS.qE, q_aV(1), 1e-4, []);

% q(6+s) = expression from OJT
qOjt = bpS.marginal_value_h(0);
checkLH.approx_equal(qOjt,  q_aV(end), 1e-4, []);

% Check growth rate of xs
g_xsV = diff(log(xs_aV)) ./ diff(ageV);
assert(max(abs(g_xsV - paramS.g_xs)) < 1e-3);


%% Test optimality of schooling against optimal stopping condition
% This holds regardless of the continuation problem

% Changing s has this effect
dVds = -paramS.r .* bpS.pv_earnings - bpS.marginal_value_T;
devOptS = -priceS.pS .* xs_aV(end) + q_aV(end) .* (F_aV(end) - paramS.deltaH .* hhS.hS) + dVds;
checkLH.approx_equal(devOptS, 0, 1e-3, []);

checkLH.approx_equal(bpS.marginal_value_age0, dVds, 1e-3, []);

% Another formula
C1 = (1 - paramS.gamma) ./ paramS.gamma1 .* (bpS.bracket_term .^ (1 ./ (1 - paramS.gamma)));
dVds2 = priceS.wage .* hhS.hS ./ (paramS.r + paramS.deltaH) .* (bpS.mprime_age(0) - paramS.r .* bpS.m_age(0)) ...
   - priceS.wage .* C1 .* (bpS.m_age(0) .^ (1 ./ (1 - paramS.gamma)));
checkLH.approx_equal(dVds2, dVds, [], 1e-3);


% *****  Test Rody's equation (10)
% Fails
% C1 = hhS.hS .* priceS.wage .* (bpS.m_age(0) - bpS.mprime_age(0) ./ (paramS.r + paramS.deltaH));
% C2 = priceS.wage .* (1 - paramS.gamma) ./ paramS.gamma1 .* ...
%    ((bpS.bracket_term .* bpS.m_age(0)) .^ (1 ./ (1 - paramS.gamma)));
% dVds2 = -(C1 + C2);
% 
% checkLH.approx_equal(dVds2, dVds, [], 1e-3);


end