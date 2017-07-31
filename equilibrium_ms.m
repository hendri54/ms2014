function outS = equilibrium_ms(countryS, paramS, cS)
% Compute equilibrium
%{
Parameters are common (from paramS), except for those in countryS
%}

assert(isa(countryS, 'CountryParamsMs'));

outS.priceS = factor_prices_ms(countryS.TFP, countryS.pk, cS);

outS.hhS = hh_solve_ms(countryS.ageRetire, outS.priceS, paramS, cS);

outS.equilS = equil_ms.solve_given_hh(outS.hhS, countryS, outS.priceS, paramS, cS);

end