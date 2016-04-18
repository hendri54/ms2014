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


%% Child care, schooling

ChildCareTestMS
SchoolProblemTestMS(setNo);


%% Household

% Solve job training problem
experV = linspace(0.01, ageRetire, 20);
hS = 9.43;
ojt_solve_ms(experV, priceS.wage, priceS.pW, ageRetire, hS, paramS, cS);

% Solve household problem
hh_test_ms(setNo);


%% Equilibrium

hbar_test_ms(setNo)
equilibrium_test_ms(setNo);
cal_dev_test_ms(setNo);


%% Helpers

var_load_test_ms(setNo);
param_load_ms(setNo);


end