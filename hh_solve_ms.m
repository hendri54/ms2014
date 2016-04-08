function outS = hh_solve_ms(ageRetire, priceS, paramS, cS)
% Solution to hh problem
%{
xs(a) has separate solution
%}

%priceS = factor_prices_ms(TFP, pk, cS);

[outS.hE, outS.hS, outS.s, outS.qE, outS.xE] = school_solve_ms(priceS, paramS, ageRetire, cS.setNo);


nAge = 100;
outS.ageV = linspace(6 + outS.s + 0.01, ageRetire, nAge);
[outS.h_aV, outS.n_aV, outS.xw_aV, outS.wageV] = ...
   ojt_solve_ms(outS.ageV, priceS.wage, priceS.pW, ageRetire, outS.s, outS.hS, paramS, cS);


end