function hh_test_ms(setNo)
% given solution to hh problem, test against other equations in the paper
%{
IN
%}

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

popGrowth = cS.tgS.fertility / cS.demogS.B;
countryS = CountryParamsMs(cS.techS.zUS, 1, popGrowth, cS.demogS.Rmax, cS.demogS.T_US);

priceS = factor_prices_ms(countryS.TFP, countryS.pk, cS);

% Solve household problem
hhS = hh_solve_ms(countryS.ageRetire, priceS, paramS, cS);


% Ages to check
nAge = 20;
ageV = linspace(6,  6 + hhS.s, nAge);

% Self test built in
[h_aV, xs_aV, q_aV] = school_ms.age_profile(ageV, hhS, priceS, paramS, cS);


end