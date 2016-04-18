function ha_school_test_ms(setNo)

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

paramS.zH = 2 * paramS.zH;

priceS = factor_prices_ms(1, 1.2, cS);

ageV = linspace(6.01, 10, 20);

hE = 0.7;
qE = 1.4;
hV = ha_school_ms(ageV, hE, qE, priceS, paramS);


% Compare with hDot equation

dAge = 1e-4;
h2V = ha_school_ms(ageV + dAge, hE, qE, priceS, paramS);
h3V = ha_school_ms(ageV - dAge, hE, qE, priceS, paramS);

hDotV = hdot_school_ms(ageV, hV, hE, qE, priceS, paramS);
hDot2V = (h2V - h3V) ./ 2 ./ dAge;
checkLH.approx_equal(hDot2V, hDotV, 1e-3, []);

end