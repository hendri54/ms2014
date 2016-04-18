function schoolS = solve_s0(spS)
% Solve school / child care problem for s=0

% OJT problem when s = 0
schoolS.s = 0;

% We don't know hE yet, but it does not matter
spS.bpS.T = spS.T;

% Marginal value of h(0)
schoolS.qE = spS.bpS.marginal_value_h(0);
schoolS.qS = schoolS.qE;

% Optimal hE when schooling is 0
[schoolS.hE, schoolS.xE] = spS.childCareS.solve_given_qe(schoolS.qE);
schoolS.hS = schoolS.hE;

% Is this consistent with the job training problem being interior?
% (13a) with inequality. now we know hE
spS.bpS.h0 = schoolS.hE;

% xS from first order condition at age 0
schoolS.xS = spS.x_age(0, schoolS.hS, schoolS.qE);


end