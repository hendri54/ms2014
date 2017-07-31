function calibr_ms(setNo)
% Calibration to US data

cS = const_ms(setNo);
paramS = param_load_ms(setNo);

solverStr = 'fminsearch';
scalarDev = true;

% Data for US
countryS = param_ms.country_data('USA', setNo);


% Make vector of guesses for calibrated parameters
guessV = cS.pvector.guess_make(paramS, 1);
fprintf('%i calibrated parameters \n',  length(guessV));

% Check that parameters and guesses are consistent
% Can only be done if objective does not return scalar deviation
if ~scalarDev
   devV = cal_dev_ms(countryS, paramS, cS);
   dev2V = cal_dev_nested(guessV);
   checkLH.approx_equal(devV, dev2V, 1e-4, []);
end



%% Check that all params affect result
if 0
   disp('Checking that all guesses affect results');
   for ig = 1 : length(guessV)
      guess2V = guessV;
      guess2V(ig) = 0.5 * (cS.pvector.guessMin + cS.pvector.guessMax);
      dev3V = cal_dev_nested(guess2V);

      assert(max(abs(dev3V - dev2V)) > 1e-2);
   end
   return
end


%% Minimization
% should use nlopt +++

% Bounds, used by some algorithms
lbV = repmat(cS.pvector.guessMin + 1e-5, size(guessV));
ubV = repmat(cS.pvector.guessMax - 1e-5, size(guessV));

optS = optimset('fminsearch');
optS.MaxFunEvals = 200;
optS.Display = 'final';
solnV = fminsearch(@cal_dev_nested, guessV, optS);

% optS = optimoptions('lsqnonlin', 'MaxFunctionEvaluations', 1e3, 'Display', 'final');
% solnV = lsqnonlin(@cal_dev_nested, guessV, lbV, ubV, optS);

[devV, devS, paramOutS] = cal_dev_nested(solnV);

var_save_ms(paramOutS, 'parameters', setNo);
devS.countryS = countryS;
var_save_ms(devS, 'cal_results', setNo);


% Compute and save equilibrium
outS = equilibrium_ms(countryS, paramOutS, cS);
var_save_ms(outS, 'equilibrium', setNo);

equil_show_ms(countryS, setNo);
disp(paramOutS);


%% Nested deviation
   function [devV, devS, paramOutS] = cal_dev_nested(guessV)
      if strcmpi(solverStr, 'fminsearch')
         if any(guessV > cS.pvector.guessMax + 1e-5)  ||  any(guessV < cS.pvector.guessMin - 1e-5)
            devV = 1e4 .* ones(size(guessV));
            if scalarDev 
               devV = 1e4;
            end
            return;
         end
      end
         
      paramS = cS.pvector.guess_extract(guessV, paramS, 1);
      [devV, devS, paramOutS] = cal_dev_ms(countryS, paramS, cS);
      if scalarDev
         devV = norm(devV);
      end
   end

end