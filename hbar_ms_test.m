function tests = hbar_ms_test

tests = functiontests(localfunctions);

end



function oneTest(testCase)

setNo = 2;
cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

TFP = 1.2;
pk = 0.9;
popGrowth = 0.02;
s = 7.1;
ageRetire = 64;
T = 75;

countryS = CountryParamsMs(TFP, pk, popGrowth, ageRetire, T);

priceS.wage = 0.8;
priceS.pE = 0.85;
priceS.pW = 1;
priceS.pS = 0.85;

massWorking = 0.37;
h6S = 3.8;

% nAge = 50;
% ageV = linspace(6+s, ageRetire, nAge);
% h_aV = linspace(2, 3, nAge);
% n_aV = linspace(0.9, 0, nAge);

hbar_ms(massWorking, h6S, s, countryS, priceS, paramS, cS);

end