function hhS = hh_solve_ms(ageRetire, priceS, paramS, cS)
% Solution to hh problem
%{
%}

% Schooling
ccS = ChildCareMS(cS.hTechS.hB, priceS.pE, paramS.v);
bpS = BenPorathContTimeLH(paramS.zH, paramS.deltaH, paramS.gamma1, paramS.gamma2, ageRetire, 1, ...
   priceS.pW, paramS.r, priceS.wage);

spS = SchoolProblemMS(paramS.zs, paramS.deltaH, paramS.beta1, paramS.beta2, ageRetire - cS.demogS.startAge, ...
   priceS.pS, paramS.r, ccS, bpS);

hhS = spS.solve;
hhS.spS = spS;

% OJT
nAge = 100;
hhS.experV = linspace(0.01, ageRetire - hhS.s - cS.demogS.startAge, nAge);
[hhS.h_aV, hhS.n_aV, hhS.xw_aV, hhS.wageV] = ...
   ojt_solve_ms(hhS.experV, priceS.wage, priceS.pW, ageRetire, hhS.hS, paramS, cS);

end