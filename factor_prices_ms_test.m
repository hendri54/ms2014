function tests = factor_prices_ms_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

setNo = 2;
cS = const_ms(setNo);
TFP = 1.2;
pk = 0.8;

priceS = factor_prices_ms(TFP, pk, cS);


[mpk, mph] = cS.outputTechS.marginal_products(TFP, priceS.kappaC);

% (9)
checkLH.approx_equal(pk * (cS.tgS.intRate + cS.techS.deltaK),  mpk,  1e-5, []);
% (10)
checkLH.approx_equal(priceS.wage, mph, 1e-5, []);

% For school tech
[mpk, mph] = cS.schoolTechS.marginal_products(TFP, priceS.kappaS);

% (9)
checkLH.approx_equal(pk * (cS.tgS.intRate + cS.techS.deltaK),  priceS.pS .* mpk,  1e-5, []);
% (10)
checkLH.approx_equal(priceS.wage, priceS.pS .* mph, 1e-5, []);


end