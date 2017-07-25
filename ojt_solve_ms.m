function [haV, naV, xwV, earnV, bpS] = ojt_solve_ms(experV, wage, pW, R, h6S, paramS, cS)
% Solve job training part for given s, h(6+s), for one age
%{
IN
   experV
      ages - work start age
   wage
      (1-tau) w
   pW
   R
      length of work period
   h6S
      h(6+s) at start of work period

%}

assert(all(experV > 0));
assert(all(experV <= R));

% Job training 
%  general purpose code
bpS = BenPorathContTimeLH(paramS.zH, paramS.deltaH, paramS.gamma1, paramS.gamma2, R, h6S, ...
   pW, paramS.r, wage);

[~, xwV] = bpS.nh(experV);
[haV, naV] = bpS.h_age(experV);
earnV = bpS.age_earnings_profile(experV);
% pvEarn = bpS.pv_earnings;


end