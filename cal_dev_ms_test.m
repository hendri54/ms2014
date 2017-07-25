function tests = cal_dev_ms_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

setNo = 2;
cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

popGrowth = cS.tgS.fertility / cS.demogS.B;
countryS = CountryParamsMs(cS.techS.zUS, 1, popGrowth, cS.demogS.Rmax, cS.demogS.T_US);

devV = cal_dev_ms(countryS, paramS, cS);


end