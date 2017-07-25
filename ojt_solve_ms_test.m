function tests = ojt_solve_ms_test

tests = functiontests(localfunctions);
      
end

function oneTest(testCase)
      
setNo = 2;
cS = const_ms(setNo);
paramS = param_load_ms(setNo);

wage = 1.2;
pW = 1.3;
R = 64;
s = 8;
h6S = 22;
experV = linspace(0.1, R-s, 20);

[haV, naV, xwV] = ojt_solve_ms(experV, wage, pW, R - s, h6S, paramS, cS);


end