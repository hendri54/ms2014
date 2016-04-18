function s_output_test_ms(setNo)

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);

s = 7;
popGrowth = 0.02;
T = 78;
massWorking = 0.37;

hE = 2.3;
qE = 3.4;
pS = 1.2;
hhXe = 0.4;


s_output_ms(hhS, popGrowth, T, massWorking, cS)
hhXe, hE, qE, pS, s, popGrowth, T, massWorking, paramS, cS);

end