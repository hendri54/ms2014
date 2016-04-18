function schoolS = solve(spS)
% Solve schooling part of the hh problem, given parameters
%{
Schooling could be 0

IN

Change: allow initial guesses +++
%}


%% Check whether schooling is 0
if true
   schoolS = spS.solve_s0;

   % Schooling = 0 if deviation from optimal schooling is < 0 and increasing in s
   devOptS  = spS.marginal_value_s(0, schoolS.hS, schoolS.xS, schoolS.qS);
   devOpt2S = spS.marginal_value_s(0.02, schoolS.hS, schoolS.xS, schoolS.qS);
   % fprintf('devOptS with s = 0  /  s = 0.05  /  change: %.3f  / %.3f  /  %f \n', devOptS, devOpt2S, devOpt2S - devOptS);
   if (devOptS < 0  &&  (devOpt2S < devOptS))  ||  (devOptS > 0  &&  (devOpt2S > devOptS))
      return
   end
end


%% Schooling is > 0

guessS.valueV = [6, 15]';
guessS.nameV = {'s',       'qE'};
guessS.lbV = [1e-2,        1e-3]';
guessS.ubV = [spS.T - 20,   1e2]';
guessS.guessMin = 1;
guessS.guessMax = 10;

if 1
   % For unbounded algorithm
   ubGuessS = optimLH.GuessUnbounded(guessS.lbV, guessS.ubV);
   guessV = ubGuessS.guesses(guessS.valueV);

   if 0
      scalarDev = true;
      
      optS = optimset('fminsearch');
      optS.MaxIter = 1e3;
      optS.Display = 'off';
      [solnV, ~, exitFlag] = fminsearch(@s_dev_unbounded, guessV, optS);
   else
      scalarDev = false;
      optS = optimoptions('fsolve', 'MaxFunctionEvaluations', 1e3, 'Display', 'off');
      [solnV, ~, exitFlag] = fsolve(@s_dev_unbounded, guessV, optS);
   end
   
   [devV, schoolS] = s_dev_unbounded(solnV);
   
else
   % Bounded algorithm
   scalarDev = false;
   
   guessV = optimLH.guess_make(guessS.valueV, guessS.lbV, guessS.ubV, guessS);

   optS = optimoptions('lsqnonlin', 'MaxFunctionEvaluations', 1e3, 'Display', 'off');
   [solnV, ~, exitFlag] = lsqnonlin(@s_dev, guessV, repmat(guessS.guessMin, size(guessV)), repmat(guessS.guessMax, size(guessV)), optS);
   
   assert(all(solnV >= guessS.guessMin));
   assert(all(solnV <= guessS.guessMax));

   if exitFlag <= 0
      warning('School problem did not converge');
   end
   
   [devV, schoolS] = s_dev(solnV);
end


% fprintf('Max dev: %f \n',  max(abs(devV)));

% fprintf('hE = %.2f    hS = %.2f    s = %.2f    qE = %.2f   xE = %.2f  \n',  ...
%    schoolS.hE, schoolS.hS, schoolS.s, schoolS.qE, schoolS.xE);


%% Nested Deviation function
function [devV, schoolS] = s_dev(guessV)
   guess2V = optimLH.guess_extract(guessV, guessS.lbV, guessS.ubV, guessS);
   s  = guess2V(1);
   qE = guess2V(2);
   
   [devV, schoolS] = spS.dev_given_s_qE(s, qE);
   if scalarDev
      devV = sum(devV .^ 2);
   end
end


%% Nested deviation for unbounded inputs
   function [devV, schoolS] = s_dev_unbounded(guessV)
      guess2V = ubGuessS.values(guessV);
      s  = guess2V(1);
      qE = guess2V(2);

      [devV, schoolS] = spS.dev_given_s_qE(s, qE);      
      if scalarDev
         devV = sum(devV .^ 2);
      end
   end


end