function hh_solve_given_s_test_ms(setNo)

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

priceS = factor_prices_ms(1.2, 0.8, cS);

ageRetire = 64;

hhS = hh_solve_ms(ageRetire, priceS, paramS, cS);

[hh2S, dev28] = hh_solve_given_s_ms(hhS.s, ageRetire, priceS, paramS, cS);

checkLH.approx_equal([hhS.hE, hhS.xE, hhS.qE, hhS.hS],  [hh2S.hE, hh2S.xE, hh2S.qE, hh2S.hS],  5e-4, []);
checkLH.approx_equal(dev28, 0,  5e-4, []);


end