function run_all_ms(setNo)

cS = const_ms(setNo);
saveFigures = 1;


%% Preparation

% Make directories
filesLH.mkdir(cS.dirS.matDir);
filesLH.mkdir(cS.dirS.outDir);

% Replicate results in MS2014 with their parameters
% Essentially a test of the schooling related code
% hh_solve_all_ms(setNo);

%% USA

% Run calibration
calibr_ms(setNo);

% Data for US
popGrowth = cS.tgS.fertility / cS.demogS.B;
countryS = CountryParamsMs(cS.techS.zUS, 1, popGrowth, cS.demogS.Rmax, cS.demogS.T_US);
equil_show_ms(countryS, setNo);


%% Comparative statics

results_ms.equil_vary_params(saveFigures, setNo);


%% Other countries

% Calibrate TFP for each country group
country_ms.calibrate_tfp(setNo)


%% Other code

% Test everything
test_all_ms;

end