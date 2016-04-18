function [hE, hS, s, qE, xE] = school_solve_ms(priceS, paramS, ageRetire, setNo)
% Solve schooling part of the hh problem, given parameters
%{
Schooling could be 0

IN
   priceS
      struct with prices: pW, pS, pE, wage
%}

cS = const_ms(setNo);


%% Check whether schooling is 0

% OJT problem when s = 0
% We don't know hE yet, but it does not matter
bpS = BenPorathContTimeLH(paramS.zH, paramS.deltaH, paramS.gamma1, paramS.gamma2, ...
    ageRetire - 6, 1, priceS.pW, paramS.r, priceS.wage);

 % Marginal value of h(6)
qE = bpS.marginal_value_h(cS.demogS.startAge);

% Child care problem
ccS = ChildCareMS(cS.hTechS.hB, priceS.pE, paramS.v);
% Optimal h(6) when schooling is 0
[hE, xE] = ccS.solve_given_qe(qE);

% Is this consistent with the job training problem being interior?
% (13a) with inequality. now we know hE
bpS.h0 = hE;
nh6 = bpS.nh(cS.demogS.startAge);

% Schooling = 0 if nh6 < h6 = hE
if nh6 < hE
   hS = hE;
   s = 0;
   return
end


%% Schooling is > 0

guessS.valueV = [1, 1, 6, 1]';
guessS.nameV = {'hE', 'hS', 's', 'qE'};
guessS.lbV = [1e-3, 1e-3, 1e-1, 1e-3]';
guessS.ubV = [1e3,  1e3,  25,   1e3]';
guessS.guessMin = 1;
guessS.guessMax = 10;

guessV = optimLH.guess_make(guessS.valueV, guessS.lbV, guessS.ubV, guessS);

%devV = s_dev(guessV)

% A bounded algorithm would make sense +++
optS = optimoptions('lsqnonlin', 'MaxFunctionEvaluations', 1e3, 'Display', 'off');
[solnV, ~, exitFlag] = lsqnonlin(@s_dev, guessV, repmat(guessS.guessMin, size(guessV)), repmat(guessS.guessMax, size(guessV)), optS);

if exitFlag <= 0
   warning('School problem did not converge');
end

assert(all(solnV >= guessS.lbV));
assert(all(solnV <= guessS.ubV));

[devV, hE, hS, s, qE] = s_dev(solnV);
%fprintf('Max dev: %f \n',  max(abs(devV)));

% From (3)
xE = (hE / cS.hTechS.hB) .^ (1 / paramS.v);

% fprintf('hE = %.2f    hS = %.2f    s = %.2f    qE = %.2f   xE = %.2f  \n',  hE, hS, s, qE, xE);


%% Solve h(s) for a fixed s

% % Does not make sense? But then why is that argument in the paper?? +++++
% hFixedS = h_school_ms(10, wage ./ pW, R, setNo);
% fprintf('h(s) with fixed s: %.2f \n', hFixedS);

% %% Solve for given schooling
% 
% fprintf('\nSolve for given schooling\n');
% 
% sModel = tbM.sModel(ig);
% hSModel = h_school_ms(sModel, wage / pW, R, setNo);
% 
% guessV = ones(1,2);
% %devV = dev_given_s(guessV)
% 
% solnV = fsolve(@dev_given_s, guessV, optS)
% fprintf('hE = %.2f    qE = %.2f  \n',  exp(solnV));
% 
% devV = dev_given_s(solnV)
% 
% 
% %% Nested: Deviaton for given schooling
%    function devV = dev_given_s(guessV)
%       guess2V = exp(guessV);
%       hE = guess2V(1);
%       qE = guess2V(2);      
%       dev26 = s_dev26(hE, hSModel, sModel, qE);
%       dev29 = s_dev29(hE, hSModel, sModel, qE);
%       devV = [dev26, dev29];
%    end


%% Nested Deviation function
function [devV, hE, hS, s, qE] = s_dev(guessV)
   guess2V = optimLH.guess_extract(guessV, guessS.lbV, guessS.ubV, guessS);
   hE = guess2V(1);
   hS = guess2V(2);
   s  = guess2V(3);
   qE = guess2V(4);
   
   devV = school_dev_ms(hE, hS, s, qE, ageRetire, priceS, paramS, cS);
end


end