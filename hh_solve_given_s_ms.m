function [hhS, dev28] = hh_solve_given_s_ms(s, ageRetire, priceS, paramS, cS)
% For calibration

hhS.s = s;
[dev28, hhS.hE, hhS.qE, hhS.xE, hhS.hS] = school_ms.dev_given_s(s, ageRetire, priceS, paramS, cS);

% repeats code from hh_solve_ms +++
nAge = 100;
hhS.ageV = linspace(6 + hhS.s + 0.01, ageRetire, nAge);
[hhS.h_aV, hhS.n_aV, hhS.xw_aV, hhS.wageV] = ...
   ojt_solve_ms(hhS.ageV, priceS.wage, priceS.pW, ageRetire, hhS.s, hhS.hS, paramS, cS);


end