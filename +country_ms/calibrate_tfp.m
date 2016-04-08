function calibrate_tfp(setNo)
% Calibrate TFP for each country group
%{
Given their values for y/yUS and for country characteristics (T, population growth, ...),
find values of TFP that match y/yUS

Assumes that calibration has been run and parameters have been saved

OUT:
   file with TFP by group
%}

cS = const_ms(setNo);
paramS = param_load_ms(setNo);

% Compute US equilibrium
countryS = param_ms.country_data('USA', setNo);
equilUS = equilibrium_ms(countryS, paramS, cS);
yUS = equilUS.equilS.y;

% Load table with data by group (from MS's paper)
tbM = load_ms(setNo);


%% Loop over groups

fzeroOptS = optimset('fzero');
fzeroOptS.Display = 'final';

saveTb = table(zeros(cS.nGroups, 1),  zeros(cS.nGroups, 1),  ...
   'VariableNames', {'TFP', 's'});

for ig = 1 : cS.nGroups
   % Country specific parameters
   countryS = param_ms.country_data(ig, setNo);
   % Target y/yUS
   tgYRatio = tbM.y(ig);
   
   [soln, fVal, exitFlag] = fzero(@dev_nested, log(0.9), fzeroOptS);
   assert(exitFlag >= 0);
   
   [~, outS] = dev_nested(soln);
   saveTb.TFP(ig) = exp(soln);
   saveTb.s(ig) = outS.hhS.s;
end

var_save_ms(saveTb, 'cal_cross_country', setNo);

saveTb


%% Nested: deviation from target output per worker
   function [dev1, outS] = dev_nested(logTFP)
      countryS.TFP = exp(logTFP);
      outS = equilibrium_ms(countryS, paramS, cS);
      dev1 = outS.equilS.y ./ yUS ./ tgYRatio - 1;
   end

end