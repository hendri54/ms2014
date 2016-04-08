function equilibrium_test_ms(setNo)

cS = const_ms(setNo);
paramS = param_load_ms(setNo);

popGrowth = cS.tgS.fertility / cS.demogS.B;
countryS = CountryParamsMs(cS.techS.zUS, 1, popGrowth, cS.demogS.Rmax, cS.demogS.T_US);

equilS = equilibrium_ms(countryS, paramS, cS);

% this is non sequitur in terms of inputs
equil_show_ms(countryS, setNo)

%keyboard;

end