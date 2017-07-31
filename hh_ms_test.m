function tests = hh_ms_test
% given solution to hh problem, test against other equations in the paper

tests = functiontests(localfunctions);

end


function [hhS, countryS, priceS, paramS, cS] = modelSetup
   setNo = 2;
   cS = const_ms(setNo);
   paramS = param_set_ms(setNo);
   paramS = param_derived_ms(paramS, cS);
   tau = 0;

   popGrowth = cS.tgS.fertility / cS.demogS.B;
   countryS = CountryParamsMs(cS.techS.zUS, 1, popGrowth, cS.demogS.Rmax, cS.demogS.T_US);

   priceS = factor_prices_ms(countryS.TFP, countryS.pk, cS);

   % Solve household problem
   hhS = hh_solve_ms(countryS.ageRetire, priceS, paramS, cS);

end


%%  OJT: x and nh
function xhTest(testCase)

   [hhS, countryS, priceS, paramS, cS] = modelSetup;
   tau = 0;


   % (17), p.2756
   x1 = paramS.zH .* (paramS.gamma1 ^ (1 - paramS.gamma2)) .* (paramS.gamma2 ^ paramS.gamma2) ./ (paramS.r + paramS.deltaH);
   x2 = (1 - tau) * priceS.wage / priceS.pW;
   Q = (x1 * x2 ^ paramS.gamma2) .^ (1 / (1 - paramS.gamma));

   % Horizon remaining
   T  =  countryS.ageRetire - hhS.s - cS.demogS.startAge;
   tV = T - hhS.experV;
   validateattributes(tV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', T})

   % m(t)
   m_tV = 1 - exp(-(paramS.r + paramS.deltaH) .* tV);

   nhV = Q .* (m_tV .^ (1 / (1 - paramS.gamma)));

   testCase.verifyEqual(nhV,  hhS.n_aV .* hhS.h_aV,  'RelTol', 1e-3);


   % (18), p. 2756

   x3 = paramS.gamma2 ./ paramS.gamma1 .* (1 - tau) .* priceS.wage ./ priceS.pW;
   x4 = paramS.zH .* paramS.gamma1 ./ (paramS.r + paramS.deltaH);
   x6 = ((x4 .* (x3 ^ paramS.gamma2)) ^ (1 / (1 - paramS.gamma)));

   xV = x3 .* x6 .* (m_tV .^ (1 ./ (1 - paramS.gamma)));

   testCase.verifyEqual(xV,  hhS.xw_aV,  'RelTol', 1e-3);
end


%%  OJT: h(a)
% (19), p. 2756
function hTest(testCase)
   [hhS, countryS, priceS, paramS, cS] = modelSetup;
   tau = 0;

   % h_aV(1) is at small, non-zero experience
   testCase.verifyEqual(hhS.hS,  hhS.h_aV(1),  'RelTol',  1e-2);

   x3 = paramS.gamma2 ./ paramS.gamma1 .* (1 - tau) .* priceS.wage ./ priceS.pW;
   x4 = paramS.zH .* paramS.gamma1 ./ (paramS.r + paramS.deltaH);
   x6 = ((x4 .* (x3 ^ paramS.gamma2)) ^ (1 / (1 - paramS.gamma)));
   x5 = (paramS.r + paramS.deltaH) ./ paramS.gamma1;
   T  =  countryS.ageRetire - hhS.s - cS.demogS.startAge;

   hV = zeros(size(hhS.experV));
   for ix = 1 : length(hhS.experV)
      exper1 = hhS.experV(ix);
      inte1 = integral(@integrand1, 0, exper1);
      hV(ix) = exp(-paramS.deltaH .* exper1) .* hhS.hS + x5 .* x6 .* inte1;
   end

   testCase.verifyEqual(hV,  hhS.h_aV,  'RelTol', 1e-3);

      % Nested:integrand
      function outV = integrand1(tV)
         m_t2V = 1 - exp(-(paramS.r + paramS.deltaH) .* (T - tV));
         outV = exp(-paramS.deltaH .* (exper1 - tV)) .* (m_t2V .^ (paramS.gamma ./ (1 - paramS.gamma)));
      end
end


%% Schooling
function schoolTest(testCase)
   [hhS, countryS, priceS, paramS, cS] = modelSetup;
   tau = 0;

   % (29), p. 2758
   hE = (paramS.v .^ (paramS.v ./ (1 - paramS.v)))  .*  (cS.hTechS.hB.^ (1 ./ (1 - paramS.v)))  .*  ...
      ((hhS.qE ./ priceS.pE).^ (paramS.v ./ (1 - paramS.v)));
   testCase.verifyEqual(hE, hhS.hE,  'RelTol', 1e-3);
   
   T = countryS.ageRetire - hhS.s - cS.demogS.startAge;
   m6S = 1 - exp(-(paramS.r + paramS.deltaH) .* T);
   
   % (26)
   x1 = paramS.zH .* (paramS.gamma1 ^ (1 - paramS.gamma2)) .* (paramS.gamma2 ^ paramS.gamma2) ./ (paramS.r + paramS.deltaH);
   x2 = (1 - tau) * priceS.wage / priceS.pW;
   Q = (x1 * x2 ^ paramS.gamma2) .^ (1 / (1 - paramS.gamma));
   hS = Q * (m6S .^ (1 / (1 - paramS.gamma)));
   testCase.verifyEqual(hS, hhS.hS, 'RelTol', 1e-3);
   
   % (27)
   x11 = hhS.qE * (hhS.hE ^ paramS.gamma1) ./ (1 - tau) ./ priceS.wage;
   x12 = exp((paramS.r + paramS.deltaH * (1 - paramS.gamma1)) * hhS.s);
   testCase.verifyEqual((paramS.r + paramS.deltaH) * x11 .* x12 ./  (hhS.hS ^ paramS.gamma1),  m6S,  ...
      'RelTol', 1e-3);
   
   % (28)
   x16 = (hhS.hE ^ (paramS.gamma - 1)) * ((hhS.qE ./ priceS.pS) ^ paramS.gamma2) * ...
      (paramS.gamma2 ^ paramS.gamma2) * paramS.zH;
   x15 = 1 + (1 - paramS.gamma1) ./ paramS.mu * (x16 .^ (1 / (1 - paramS.gamma2))) * ...
      (exp(paramS.mu * hhS.s) - 1);
   hS = hhS.hE * exp(-paramS.deltaH * hhS.s) * (x15 ^ (1 / (1 - paramS.gamma1)));
   testCase.verifyEqual(hS, hhS.hS,  'RelTol', 1e-4);
end

