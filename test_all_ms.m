function test_all_ms(setNo)

cS = const_ms(setNo);
paramS = param_set_ms(setNo);
paramS = param_derived_ms(paramS, cS);
ageRetire = cS.demogS.Rmax;
TFP = 1;
pk = 1;

factor_prices_test_ms(setNo)

% Factor prices
priceS = factor_prices_ms(TFP, pk, cS);


%% Child care

ChildCareTestMS


%% Schooling


% Deviation from schooling equations
hE = 2.3;
hS = 10.1;
s = 9.2;
qE = 3.7;

eqn_ms.s_dev26(qE, hE, s, ageRetire, priceS, paramS);
school_ms.qe_he_from26_test(setNo);

school_dev_ms(hE, hS, s, qE, ageRetire, priceS, paramS, cS);

% h(6+s)
school_ms.h_school(7.3, 1.1, 1.8, ageRetire, paramS, cS);

% Solve school problem
[hE, hS, s, qE] = school_solve_ms(priceS, paramS, ageRetire, setNo);

school_solve_test_ms(setNo);
% hh_solve_given_s_test_ms(setNo)

% This currently fails b/c the equation for h(a) is likely wrong +++++
% ha_school_test_ms(setNo)


%% Household

% Solve job training problem
experV = linspace(s+0.1, ageRetire, 20) - s;
ojt_solve_ms(experV, priceS.wage, priceS.pW, ageRetire - s, hS, paramS, cS);

% Solve household problem
hh_test_ms(setNo);


%% Equilibrium

hbar_test_ms(setNo)
s_output_test_ms(setNo)
equilibrium_test_ms(setNo);
cal_dev_test_ms(setNo);


%% Helpers

var_load_test_ms(setNo);
param_load_ms(setNo);


end