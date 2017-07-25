function tests = calibr_ms_test
% Check that calibration recovers equilibrium
%{
Does not recover what was computed during calibration (because s is not matched exactly)
%}

tests = functiontests(localfunctions);


end


function oneTest(testCase)


setNo = 2;
cS = const_ms(setNo);

% Assumes that calibration has run
devS = var_load_ms('cal_results', setNo);
paramS = var_load_ms('parameters', setNo);


%% Check that equilibrium is recovered

outS = equilibrium_ms(devS.countryS, paramS, cS);

fieldV = {'hE', 'qE', 'hS', 's', 'xS'};
for i1 = 1 : length(fieldV)
   fName = fieldV{i1};
   checkLH.approx_equal(devS.hhS.(fName),  outS.hhS.(fName), 1e-3, []);
end


end