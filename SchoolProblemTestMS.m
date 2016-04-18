function SchoolProblemTestMS(setNo)

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);
ageRetire = cS.demogS.Rmax - cS.demogS.startAge;


%% Set parameters

% Use same params and prices for schooling and OJT?
sameParams = false;

paramS.beta1 = 0.38;
paramS.beta2 = 0.31;
paramS.zs = paramS.zH;

paramS.beta1 = paramS.gamma1;
paramS.beta2 = paramS.gamma2; % +++++

if sameParams
   % Start with MS's parameters
   paramS.beta1 = paramS.gamma1;
   paramS.beta2 = paramS.gamma2;
   paramS.zs = paramS.zH;
end


% Try such that s = 0
% paramS.zs = 0.15; % +++++
% paramS.zH = paramS.zs;

% Factor prices
TFP = 1;
pk = 1;
priceS = factor_prices_ms(TFP, pk, cS);

if true
   priceS.pS = 0.99;
   sameParams = false;
end

if false
   priceS.pS = 0.99;
   priceS.pE = 0.99;
   priceS.pW = 0.99;
end


%% Solve and check

ccS = ChildCareMS(cS.hTechS.hB, priceS.pE, paramS.v);
bpS = BenPorathContTimeLH(paramS.zH, paramS.deltaH, paramS.gamma1, paramS.gamma2, ageRetire, 1, ...
   priceS.pW, paramS.r, priceS.wage);

spS = SchoolProblemMS(paramS.zs, paramS.deltaH, paramS.beta1, paramS.beta2, ageRetire, priceS.pS, paramS.r, ccS, bpS);
schoolS = spS.solve;

checkLH.approx_equal(spS.gamma, paramS.beta1 + paramS.beta2, 1e-6, []);


% Check optimality conditions
check_optimality_ms(schoolS, spS, bpS, sameParams);

% Check against solution for given s
check_given_s(schoolS, spS);

% Check marginal value of s
check_mvalue_s(spS)

check_age_profiles(schoolS, spS);

fprintf('Testing SchoolProblemMS done \n');

end

% --------- Local function start here

%% Age profiles
% Ages relative to start of school
function check_age_profiles(schoolS, spS)
   if schoolS.s > 1
      nAge = round(100 .* schoolS.s);
      ageV = linspace(0, schoolS.s, nAge)';

      [h_aV, xs_aV, q_aV, F_aV] = spS.age_profile(ageV, schoolS.hE, schoolS.qE);

      hDotV = diff(h_aV) ./ diff(ageV);
      qDotV = diff(q_aV) ./ diff(ageV);

      % foc for xs (13b)
      dev13bV = spS.dev_foc_xs(h_aV, xs_aV, q_aV);
      assert(max(abs(dev13bV)) < 1e-4);

      % (13c)
      rhsV = q_aV .* (spS.r - F_aV ./ h_aV .* spS.gamma1 + spS.deltaH);
      checkLH.approx_equal(qDotV, 0.5 .* (rhsV(1 : (nAge-1)) + rhsV(2:nAge)), 1e-3, []);

      % (13d)
      rhsV = F_aV - spS.deltaH .* h_aV;
      checkLH.approx_equal(hDotV, 0.5 .* (rhsV(1 : (nAge-1)) + rhsV(2:nAge)), 1e-3, []);

      % qE = q(0)
      checkLH.approx_equal(schoolS.qE, q_aV(1), 1e-4, []);

      % Initial condition
      checkLH.approx_equal(h_aV(1), schoolS.hE, 1e-4, []);

      % Terminal condition
      checkLH.approx_equal(schoolS.qS,  q_aV(end), 1e-4, []);

      % Check growth rate of xs
      g_xsV = diff(log(xs_aV)) ./ diff(ageV);
      assert(max(abs(g_xsV - spS.g_xs)) < 1e-3);
   end
end

%% Local: check optimality conditions
function check_optimality_ms(schoolS, spS, bpS, sameParams)
   if schoolS.s > 0.01
      devV = spS.dev_given_s_qE(schoolS.s, schoolS.qE);
      checkLH.approx_equal(devV, zeros(size(devV)), 1e-4, []);

      devOptS = spS.marginal_value_s(schoolS.s, schoolS.hS, schoolS.xS, schoolS.qS);
      checkLH.approx_equal(devOptS, 0, 1e-4, []);
   end

   % eqn for h and q
   [hS, xS, qS] = spS.h_school(schoolS.s, schoolS.hE, schoolS.qE);
   checkLH.approx_equal([hS, xS, qS], [schoolS.hS, schoolS.xS, schoolS.qS], 1e-4, []);

   devQH = spS.dev_qhG1(schoolS.hE, schoolS.qE, schoolS.s, schoolS.hS, schoolS.qS);
   checkLH.approx_equal(devQH, 0, 1e-4, []);

   % q(s) = expression from OJT
   bpS.T = spS.T - schoolS.s;
   qOjt = bpS.marginal_value_h(0);
   checkLH.approx_equal(schoolS.qS, qOjt, 1e-4, []);
   
   % If n=1 at start of work, we can check the alternative terminal condition 
   if sameParams
      % p 2756 or (27)
      m6S = spS.bpS.m_age(0);
      bTerm = spS.bpS.bracket_term;
      % (27)
      hS2 = (bTerm .* m6S) .^ (1 / (1 - spS.bpS.gamma));
      checkLH.approx_equal(hS2, schoolS.hS, [], 1e-3);
   end
end


%% Local: Solve for given s
function check_given_s(schoolS, spS)
   [marginalValueS, school2S, value] = spS.solve_given_s(schoolS.s);
   checkLH.approx_equal([schoolS.hE, schoolS.qE, schoolS.hS], [school2S.hE, school2S.qE, school2S.hS], ...
      1e-3, []);
   checkLH.approx_equal(marginalValueS, 0, 1e-3, []);

   % Plot deviation from optimal schooling condition against s
   if true
      sV = linspace(6, 14, 30)';
      valueV = zeros(size(sV));
      devOptSV = zeros(size(sV));
      HV = zeros(size(sV));
      dVdsV = zeros(size(sV));
      for i1 = 1 : length(sV)
         [devOptSV(i1), schoolS, valueV(i1)] = spS.solve_given_s(sV(i1));
         % Hamiltonian
         HV(i1) = -spS.pS .* schoolS.xS  +  schoolS.qS .* (spS.htech(schoolS.hS, schoolS.xS) - spS.deltaH * schoolS.hS);
         % Marginal value of s on OJT
         spS.bpS.T = spS.T - sV(i1);
         dVdsV(i1) = spS.bpS.marginal_value_age0;
      end
      disp('Schooling  mValueS  Hamilt  dVds  value');
      disp([sV, devOptSV, HV, dVdsV valueV - valueV(1)]);
      keyboard;
   end

   
   % Check optimality of s
   ds = 1e-2;
   [~,~, valueHigh] = spS.solve_given_s(schoolS.s + ds);
   [~,~, valueLow] = spS.solve_given_s(schoolS.s - ds);   
   assert(valueHigh < value);
   assert(valueLow  < value);   
end

%% Local: check marginal value of s
function check_mvalue_s(spS)
   s0 = 5;
   ds = 1e-3;
   [marginalValueS, ~, value] = spS.solve_given_s(s0);
   [~, ~, value2] = spS.solve_given_s(s0 + ds);
   checkLH.approx_equal(marginalValueS,  (value2 - value) ./ ds,  1e-4, []);
end