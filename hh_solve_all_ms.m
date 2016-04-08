function hh_solve_all_ms(setNo)
% Replicating result tables using MS's parameters

cS = const_ms(setNo);
paramS = param_set_ms(setNo);

% Using MS's parameters
paramS.gamma1 = 0.486036;
paramS.gamma2 = 0.4;
paramS.gamma = paramS.gamma1 + paramS.gamma2;
paramS.g1g = paramS.gamma1 / paramS.gamma;
paramS.v = 0.618;
paramS.deltaH = 0.027;

paramS = param_derived_ms(paramS, cS);


%% USA

priceS = factor_prices_ms(cS.techS.zUS, 1, cS);
[hE, hS, s, qE] = school_solve_ms(priceS, paramS, cS.demogS.Rmax, setNo);

fprintf('\nUSA\n');
fprintf('hE = %.2f    hS = %.2f    s = %.2f    qE = %.2f \n',  hE, hS, s, qE);



%%  Solve for schooling

% Solve for prices and other stats that do not require solution of hh problem
tbM = load_ms(setNo);

tbM.hE = zeros(cS.nGroups, 1);
tbM.qE = zeros(cS.nGroups, 1);
tbM.hS = zeros(cS.nGroups, 1);
tbM.school = zeros(cS.nGroups, 1);
tbM.wage = zeros(cS.nGroups, 1);
tbM.pW = zeros(cS.nGroups, 1);
tbM.pS = zeros(cS.nGroups, 1);
tbM.pE = zeros(cS.nGroups, 1);

for ig = 1 : cS.nGroups
   priceS = factor_prices_ms(tbM.TFP(ig), tbM.pk(ig), cS);
   tbM.wage(ig) = priceS.wage;
   tbM.pW(ig) = priceS.pW;
   tbM.pS(ig) = priceS.pS;
   tbM.pE(ig) = priceS.pE;
   
   [tbM.hE(ig), tbM.hS(ig), tbM.school(ig), tbM.qE(ig)] = school_solve_ms(priceS, paramS, tbM.ageRetire(ig), setNo);
end

tbM.hE = tbM.hE ./ tbM.hE(1);
tbM.hS = tbM.hS ./ tbM.hS(1);
tbM.qE = tbM.qE ./ tbM.qE(1);

disp(tbM)



%% Solve OJT

tau = cS.taxRate;

nAge = 40;
saveS.age_agM = zeros(nAge, cS.nGroups);
saveS.h_agM = zeros(nAge, cS.nGroups);
saveS.n_agM = zeros(nAge, cS.nGroups);
saveS.xw_agM = zeros(nAge, cS.nGroups);

for ig = 1 : cS.nGroups
   ageV = linspace(6 + tbM.school(ig) + 0.1, tbM.ageRetire(ig), nAge);
   saveS.age_agM(:,ig) = ageV;
   
   [saveS.h_agM(:,ig), saveS.n_agM(:,ig), saveS.xw_agM(:,ig)] = ...
      ojt_solve_ms(ageV, (1 - tau) * tbM.wage(ig), tbM.pW(ig), ...
      tbM.ageRetire(ig), tbM.school(ig), tbM.hS(ig), paramS, cS);
   
   saveS.wage_agM(:, ig) = (1-tau) .* tbM.wage(ig) .* saveS.h_agM(:,ig) .* ...
      (1 - saveS.n_agM(:,ig)) - tbM.pW(ig) .* saveS.xw_agM(:,ig);
end



% save
saveS.tbM = tbM;
save(fullfile(cS.dirS.matDir, 'hh_solution.mat'), 'saveS');


end