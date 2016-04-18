function [marginalValueS, schoolS, value] = solve_given_s(spS, s)
% Solve schooling part of the hh problem, given parameters and s
%{
Schooling could be 0

OUT
   marginaValueS
      marginal value of increasing schooling
      deviation from optimal schooling condition
   value
      present value of lifetime earnings net of xs
%}


if s == 0
   schoolS = spS.solve_s0;

   % Schooling = 0 if deviation from optimal schooling is < 0 and increasing in s
   marginalValueS  = spS.marginal_value_s(0, schoolS.hS, schoolS.xS, schoolS.qS);
      
else
   % Schooling is > 0
   % Find qE
   qE = 2;

   optS = optimset('fzero');
   optS.MaxIter = 1e3;
   optS.Display = 'off';
   
   % Plot deviation function
   if false
      qEV = linspace(1e-2, 1e2, 10);
      devV = zeros(size(qEV));
      for i1 = 1 : length(qEV)
         devV(i1) = s_dev(log(qEV(i1)));
      end
      disp([qEV(:), devV(:)]);
      keyboard;
   end
   
   [solnV, ~, exitFlag] = fzero(@s_dev, log(qE), optS);
   
   if exitFlag <= 0
      warning('School solution not found')
   end

   [devQH, marginalValueS, schoolS] = s_dev(solnV);

   % fprintf('Max dev: %f \n',  max(abs(devV)));
end


% Value
value = spS.value_fct(schoolS);


%% Nested Deviation function
function [devQH, devOptS, schoolS] = s_dev(guessV)
   qE2 = exp(guessV) + 1e-3;
   
   [~, schoolS, devOptS, devQH] = spS.dev_given_s_qE(s, qE2);
end


end