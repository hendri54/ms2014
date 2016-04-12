function ChildCareTestMS

v = 0.6;
hB = 3;
pE = 1.2;
qE = 0.93;

ccS = ChildCareMS(hB, pE, v);

[hE, xE] = ccS.solve_given_qe(qE);

v0 = ccS.value(qE, xE);

assert(ccS.value(qE, xE + 1e-4) < v0)
assert(ccS.value(qE, xE - 1e-4) < v0)


end