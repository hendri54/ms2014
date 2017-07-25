function tests = hh_ms_test
% given solution to hh problem, test against other equations in the paper

tests = functiontests(localfunctions);

end


function oneTest(testCase)

setNo = 2;
cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

popGrowth = cS.tgS.fertility / cS.demogS.B;
countryS = CountryParamsMs(cS.techS.zUS, 1, popGrowth, cS.demogS.Rmax, cS.demogS.T_US);

priceS = factor_prices_ms(countryS.TFP, countryS.pk, cS);

% Solve household problem
hhS = hh_solve_ms(countryS.ageRetire, priceS, paramS, cS);


end