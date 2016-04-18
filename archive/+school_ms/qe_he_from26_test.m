function qe_he_from26_test(setNo)

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

priceS = factor_prices_ms(1.2, 0.8, cS);

s = 12;
ageRetire = 64;

out1 = school_ms.qe_he_from26(s, ageRetire, priceS, paramS);

qE = 1.2;
hE = (out1 ./ qE) .^ (1 / paramS.gamma1);
checkLH.approx_equal(qE .* (hE .^ paramS.gamma1),  out1,  1e-5, []);

dev26 = eqn_ms.s_dev26(qE, hE, s, ageRetire, priceS, paramS);
assert(abs(dev26) < 1e-5);


end