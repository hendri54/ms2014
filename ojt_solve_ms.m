function [haV, naV, xwV, earnV, bpS] = ojt_solve_ms(ageV, wage, pW, R, s, h6S, paramS, cS)
% Solve job training part for given s, h(6+s), for one age
%{
IN
   ageV
      ages
   wage
      (1-tau) w
   pW
   R
      retirement age
   s
      schooling
   h6S
      h(6+s)

%}

assert(all(ageV > 6+s));
assert(all(ageV <= R));

%    %% Define names
% 
%    zH = paramS.zH;
%    r = paramS.r;
%    deltaH = paramS.deltaH;
%    % R = tbM.ageRetire(ig);
%    gamma1 = paramS.gamma1;
%    gamma2 = paramS.gamma2;
%    pGamma = paramS.gamma;
%    wage_pW = wage / pW;


% Job training 
%  general purpose code
bpS = BenPorathContTimeLH(paramS.zH, paramS.deltaH, paramS.gamma1, paramS.gamma2, R - s, h6S, ...
   pW, paramS.r, wage);

experV = ageV - 6 - s;
[~, xwV] = bpS.nh(experV);
[haV, naV] = bpS.h_age(experV);
earnV = bpS.age_earnings_profile(experV);
% pvEarn = bpS.pv_earnings;


% 
%    %% n(a) h(a) from (17)
%    % This agrees with MS
% 
%    c1  = zH .* (gamma1 .^ (1 - gamma2)) .* (gamma2 .^ gamma2) ./ (r + deltaH);
%    c2  = wage_pW .^ gamma2;
%    maV = m_age_ms(ageV, R, deltaH, r);
% 
%    nhV  = (c1 .* c2 .* maV)  .^ (1 / (1-pGamma));
%    validateattributes(nhV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%       '>=', 0, 'size', size(ageV)})
%    clear c1 c2;
% 
% 
%    %% x(a) from (18)
%    % this is where MS2014 have a mistake
% 
%    c1 = gamma2 / gamma1 * wage_pW;
%    % This term is reused below!
%    c2 = zH * gamma1 / (r + deltaH) * ((gamma2 / gamma1 * wage_pW) ^ gamma2);
% 
%    xwV = c1 .* ((c2 .* maV) .^ (1 / (1-pGamma)));
%    validateattributes(xwV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%       '>=', 0, 'size', size(ageV)})
% 
% 
% 
%    %% h(a) from (19)
% 
%    % c2 from the x(a) equation
% 
%    c3V = zeros(size(ageV));
%    for i1 = 1 : length(ageV)
%       age = ageV(i1);
%       c3V(i1) = integral(@c3_integrand,  6+s,  ageV(i1));
%    end
%    validateattributes(c3V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%       '>=', 0, 'size', size(ageV)})
% 
%    haV = exp(-deltaH .* (ageV - 6 - s)) .* h6S  +  ...
%       (r + deltaH) ./ gamma1 .* (c2 .^ (1 / (1 - pGamma))) .* c3V;
%    validateattributes(haV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%       '>', 0, 'size', size(ageV)})
% 
%    naV = nhV ./ haV;
%    validateattributes(naV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%       '>=', 0, 'size', size(ageV)})
% 
% 
%    %% Nested: integrand for c3
%       function x = c3_integrand(tV)
%          mtV = max(0, 1 - exp(-(r + deltaH) .* (R - tV)));
%          x = exp(-deltaH .* (age - tV)) .* (mtV .^ (pGamma / (1 - pGamma)));
%          validateattributes(x, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%             '>=', 0})
%       end

end