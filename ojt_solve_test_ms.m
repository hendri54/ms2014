function ojt_solve_test_ms(setNo)

cS = const_ms(setNo);

wage = 1.2;
pW = 1.3;
R = 64;
s = 8;
h6S = 22;
ageV = (6 + s + 1) : R;

[haV, naV, xwV] = ojt_solve_ms(ageV, wage, pW, R, s, h6S, cS);

keyboard;


end