function run_all_ms(setNo)

cS = const_ms(setNo);

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


%% Other countries



%% Other code

% Test everything
test_all_ms(setNo);

end