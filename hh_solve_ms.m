function outS = hh_solve_ms(ageRetire, priceS, paramS, cS)
% Solution to hh problem
%{
%}

ccS = ChildCareMS(cS.hTechS.hB, priceS.pE, paramS.v);
bpS = BenPorathContTimeLH(paramS.zH, paramS.deltaH, paramS.gamma1, paramS.gamma2, ageRetire, 1, ...
   priceS.pW, paramS.r, priceS.wage);

spS = SchoolProblemMS(paramS.zs, paramS.deltaH, paramS.beta1, paramS.beta2, ageRetire - cS.demogS.startAge, ...
   priceS.pS, paramS.r, ccS, bpS);

outS = spS.solve;

% [outS.hE, outS.hS, outS.s, outS.qE, outS.xE] = ...
%    school_solve_ms(priceS, paramS, ageRetire, cS.setNo);


nAge = 100;
outS.experV = linspace(0.01, ageRetire - outS.s - cS.demogS.startAge, nAge);
[outS.h_aV, outS.n_aV, outS.xw_aV, outS.wageV] = ...
   ojt_solve_ms(outS.experV, priceS.wage, priceS.pW, ageRetire, outS.s, outS.hS, paramS, cS);


end