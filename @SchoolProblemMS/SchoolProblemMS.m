% School problem in MS 2014
%{
Technology: z h^gamma1 x^gamma2

Ages are relative to start of school

Methods not in this file
   solve
      solve school problem
%}
classdef SchoolProblemMS
   
properties
   % productivity parameter
   z double
   deltaH double
   gamma1 double
   gamma2 double
   % Length of work + school time
   T double
   % Price of input
   pS double
   % Interest rate
   r  double
   % Child care sub-problem
   childCareS ChildCareMS
   % Ben-Porath continuation value (need not be Ben-Porath)
   bpS BenPorathContTimeLH
end

properties (Dependent)
   gamma 
   % Growth rate of x(s)
   g_xs
   mu
end

methods
   %% Constructor
   function spS = SchoolProblemMS(z, deltaH, gamma1, gamma2, T, pS, r, ccS, bpS)
      spS.z = z;
      spS.deltaH = deltaH;
      spS.gamma1 = gamma1;
      spS.gamma2 = gamma2;
      spS.T = T;
      spS.pS = pS;
      spS.r = r;
      spS.childCareS = ccS;
      spS.bpS = bpS;
      
      spS.validate;
   end
   
   function validate(spS)
      assert((spS.deltaH >= 0)  &&  (spS.deltaH < 0.2));
      validateattributes(spS.T, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 20, '<', 100})
      assert((spS.r > 0)  &&  (spS.r < 0.15));
      assert(spS.gamma < 0.99);
   end
   
   
   %% Dependent properties
   function gma = get.gamma(spS)
      gma = spS.gamma1 + spS.gamma2;
      assert(gma < 1);
   end
   
   % Checked: 2016-Apr-15
   function gxs = get.g_xs(spS)
      gxs = (spS.r + spS.deltaH .* (1 - spS.gamma1)) ./ (1 - spS.gamma2);
   end
   
   % Checked: 2016-Apr-15
   function muOut = get.mu(spS)
      muOut = (spS.gamma2 * spS.r + spS.deltaH * (1 - spS.gamma1)) / (1 - spS.gamma2);
   end
   
   
   
   %% Deviations from optimality, given s, qE
   % Checked: 2016-Apr-15
   function [devV, schoolS, devOptS, devQH] = dev_given_s_qE(spS, s, qE)
      schoolS.s = s;
      schoolS.qE = qE;
      [schoolS.hE, schoolS.xE] = spS.childCareS.solve_given_qe(qE);
      [schoolS.hS, schoolS.xS, schoolS.qS] = spS.h_school(s, schoolS.hE, qE);
      
      % Deviations:
      % growth of q h^gamma1 (25)
      devQH = spS.dev_qhG1(schoolS.hE, qE, s, schoolS.hS, schoolS.qS);
      % optimality of s
      devOptS = spS.marginal_value_s(s, schoolS.hS, schoolS.xS, schoolS.qS);
      devV = [devQH; devOptS];
      
      validateattributes(devV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [2, 1]})
   end
   
   
   %% Solving for individual pieces

   
   % Compute h(s), x(s), q(s) given s
   %{
   IN
      sV
         years of schooling
   Checked: 2016-Apr-15
   %}
   function [hSchoolV, xsV, qsV] = h_school(spS, sV, hE, qE)
      assert(all(spS.T - sV > 1e-2));
      hSchoolV = zeros(size(sV));
      qsV = zeros(size(sV));
      
      % For (28)
      c28a = ((hE ^ (spS.gamma-1)) * spS.z * ((qE / spS.pS * spS.gamma2) ^ spS.gamma2)) ^ (1/(1-spS.gamma2));
      
      for i1 = 1 : length(sV)
         s = sV(i1);
         % (28)
         c28 = 1 + (1 - spS.gamma1) / spS.mu * c28a * (exp(spS.mu * s) - 1);
         hSchoolV(i1) = hE * exp(-spS.deltaH * s) * (c28 ^ (1 / (1-spS.gamma1)));
         
         % Time for work
         spS.bpS.T = spS.T - s;
         spS.bpS.h0 = hSchoolV(i1);        

         % q at end of school = q at start of work
         qsV(i1) = spS.bpS.marginal_value_h(0);
      end
      
      validateattributes(hSchoolV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      validateattributes(qsV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      
      xsV = (spS.z .* spS.gamma2 ./ spS.pS .* qsV .* (hSchoolV .^ spS.gamma1)) .^ (1 ./ (1 - spS.gamma2));
      validateattributes(xsV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end   
   
   
   %% Age profiles
   
   % Compute age profile during schooling
   % Checked: 2016-Apr-15
   function [h_aV, xs_aV, q_aV, F_aV] = age_profile(spS, ageV, hE, qE)
      validateattributes(ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})
      h_aV = spS.h_age(ageV, hE, qE);
      xs_aV = spS.x_age(ageV, hE, qE);      
      q_aV = spS.q_age(ageV, h_aV, hE, qE);
      F_aV = spS.htech(h_aV, xs_aV);
   end
   
   
   % h(a) Eqn 22
   function hV = h_age(spS, ageV, hE, qE)
      validateattributes(ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})

      C2 = (hE .^ (spS.gamma - 1))  .*  ((qE ./ spS.pS .* spS.gamma2) .^ spS.gamma2)  .*  spS.z;
      C3 = exp(spS.mu .* ageV) - 1;
      C1 = 1 + (1 - spS.gamma1) ./ spS.mu .* (C2 .^ (1 / (1-spS.gamma2))) .* C3;

      hV = hE .* exp(-spS.deltaH .* ageV) .* (C1 .^ (1 / (1 - spS.gamma1)));

      validateattributes(hV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', size(ageV)})
   end   
   
   % F(h,x)
   function F_aV = htech(spS, h_aV, xs_aV)
      F_aV = spS.z .* (h_aV .^ spS.gamma1) .* (xs_aV .^ spS.gamma2);
   end
   
   % xs(a) from (21)
   function xsV = x_age(spS, ageV, hE, qE)
      c1 = (hE ^ spS.gamma1) .* qE ./ spS.pS .* spS.gamma2 .* spS.z;

      c2 = exp(spS.g_xs .* ageV);

      xsV = c1 .^ (1 / (1 - spS.gamma2)) .* c2;
      validateattributes(xsV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, 'size', size(ageV)})
   end
   
   
   % q(a) h(a) ^ gamma1
   % Checked: 2016-Apr-15
   function qhG1_aV = qhG1(spS, ageV, hE, qE)
      % (25)
      qhG1_aV = qE .* (hE .^ spS.gamma1) .* exp((spS.r + spS.deltaH .* (1 - spS.gamma1)) .* ageV);
   end
   
   % q(a)
   function q_aV = q_age(spS, ageV, h_aV, hE, qE)
      % (q(a) * h(a)) ^ gamma1 from (25)
      qhV = spS.qhG1(ageV, hE, qE);
      q_aV = qhV ./ (h_aV .^ spS.gamma1);
   end
   
   
   %% Deviations from optimality conditions
   
   % Optimality for s
   %{
   Returns the marginal value of increasing s
   devOptS = 0 for interior s
   
   Checked: 2016-Apr-15
   %}
   function devOptS = marginal_value_s(spS, s, hS, xS, qS)
      % -rV + dV/ds, remaining work time is T-s
      spS.bpS.T = spS.T - s;   
      spS.bpS.h0 = hS;
      dVds = spS.bpS.marginal_value_age0;
      
      devOptS = -spS.pS .* xS + qS .* (spS.htech(hS, xS) - spS.deltaH .* hS) + dVds;
   end

   
   % FOC for xs
   % Checked: 2016-Apr-15
   function devV = dev_foc_xs(spS, h_aV, xs_aV, q_aV)
      lhsV = spS.pS .* xs_aV;
      rhsV = q_aV .* spS.gamma2 .* spS.z .* (h_aV .^ spS.gamma1) .* (xs_aV .^ spS.gamma2);
      devV = lhsV - rhsV;
      validateattributes(devV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   end   
   
   % Growth of q h^gamma1
   % Checked: 2016-Apr-15
   function devQH = dev_qhG1(spS, hE, qE, s, hS, qS)
      devQH = spS.qhG1(s, hE, qE) - (qS .* (hS .^ spS.gamma1));
   end


   % Eqn (26) (does not hold any more) (really a version of qE hE^gamma1 equation)
%    function dev26 = dev26(spS, qE, hE, s)
% 
%       rdh = spS.r + spS.deltaH;
%       m6S = spS.bpS.m_age(s);
%       bTerm = spS.bpS.bracket_term;
% 
%       lhs = m6S ./ rdh;
% 
%       C1 = exp((spS.r + spS.deltaH * (1 - spS.gamma1)) * s);
% 
%       rhs = qE .* (hE .^ spS.gamma1) ./ priceS.wage .* C1 ./ ((bTerm .* m6S) .^ (spS.gamma1 ./ (1 - spS.gamma)));
% 
%       dev26 = lhs  -  rhs;
%       validateattributes(dev26, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
%    end

end
   
end