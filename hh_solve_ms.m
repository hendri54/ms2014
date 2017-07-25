function hhS = hh_solve_ms(ageRetire, priceS, paramS, cS)
% Solution to hh problem
%{
IN
   ageRetire  ::  double
      physical retirement age, e.g. 64
%}

% Schooling
ccS = ChildCareMS(cS.hTechS.hB, priceS.pE, paramS.v);
% Don't know the time horizon for the BP problem yet. Just pass ageRetire for now. School problem
% overrides this when school duration is known
bpS = BenPorathContTimeLH(paramS.zH, paramS.deltaH, paramS.gamma1, paramS.gamma2, ageRetire, 1, ...
   priceS.pW, paramS.r, priceS.wage);

spS = SchoolProblemMS(paramS.zs, paramS.deltaH, paramS.beta1, paramS.beta2, ageRetire - cS.demogS.startAge, ...
   priceS.pS, paramS.r, ccS, bpS);

hhS = spS.solve;
hhS.spS = spS;

% OJT
nAge = 100;
% Length of work period
Tmax = ageRetire - hhS.s - cS.demogS.startAge;
hhS.experV = linspace(0.01, Tmax, nAge);
[hhS.h_aV, hhS.n_aV, hhS.xw_aV, hhS.wageV] = ...
   ojt_solve_ms(hhS.experV, priceS.wage, priceS.pW, Tmax, hhS.hS, paramS, cS);

validateattributes(hhS.n_aV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1})

end