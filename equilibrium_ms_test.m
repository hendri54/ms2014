function tests = equilibrium_ms_test

tests = functiontests(localfunctions);

end


%% Syntax test
function oneTest(testCase)

setNo = 2;
cS = const_ms(setNo);
paramS = param_load_ms(setNo);

popGrowth = cS.tgS.fertility / cS.demogS.B;
countryS = CountryParamsMs(cS.techS.zUS, 1, popGrowth, cS.demogS.Rmax, cS.demogS.T_US);

equilS = equilibrium_ms(countryS, paramS, cS);

% this is non sequitur in terms of inputs
equil_show_ms(countryS, setNo)

%keyboard;

end


%% hBar
% Requires saved calibration
function hBarTest(testCase)
   setNo = 2;
   calS = var_load_ms('cal_results', setNo);
   %equilS = var_load_ms('equilibrium', setNo);
   hhS = calS.hhS;
   equilS = calS.equilS;
   
   % Age in experience profiles
   cS = const_ms(setNo);
   ageV = hhS.experV + hhS.s + cS.demogS.startAge;
   
   testCase.verifyEqual(ageV(end), calS.countryS.ageRetire,  'RelTol', 1e-3);
   
   % Phi(a) from (8)
   % T in this function, not retirement age
   phi_aV = phi_age_ms(ageV, calS.countryS.popGrowth, calS.countryS.T);
   
   massWorking = trapz(ageV, phi_aV);
   testCase.verifyEqual(massWorking, equilS.massWorking, 'RelTol', 1e-3);
   
   % hBar
   hBar = trapz(ageV, hhS.h_aV .* (1 - hhS.n_aV) .* phi_aV) ./ massWorking;
   testCase.verifyEqual(hBar, equilS.hBar, 'RelTol', 1e-3);
end