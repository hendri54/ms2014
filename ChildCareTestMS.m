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


% Check (29)
dev29 = hE - ((v * qE / pE) .^ (v / (1-v)))  *  (hB ^ (1/(1-v)));
checkLH.approx_equal(dev29, 0, 1e-5, []);

end