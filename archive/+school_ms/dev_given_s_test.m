function dev_given_s_test(setNo)

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

priceS = factor_prices_ms(1.2, 0.8, cS);

s = 12;
ageRetire = 64;

school_ms.dev_given_s(s, ageRetire, priceS, paramS, cS);

end