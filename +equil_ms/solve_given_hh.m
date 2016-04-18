function equilS = solve_given_hh(hhS, countryS, priceS, paramS, cS)
% Solve equilibrium, given solution to hh problem

% Mass of working persons
equilS.massWorking = integral(@(x) phi_age_ms(x, countryS.popGrowth, countryS.T),  ...
   cS.demogS.startAge + hhS.s, countryS.ageRetire);

% Average h
equilS.hBar = hbar_ms(equilS.massWorking, hhS.hS, hhS.s, countryS, priceS, paramS, cS);

% Output required in s sector
[equilS.ys, equilS.xs, equilS.xe] = ...
   s_output_ms(hhS, countryS.popGrowth, countryS.T, equilS.massWorking, cS);

% Output in s sector / hs
equilS.y_hs = cS.schoolTechS.output(countryS.TFP, priceS.kappaS);

% h in s sector (producing xs and xe)
equilS.hBarS = equilS.ys ./ equilS.y_hs;
validateattributes(equilS.hBarS, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})

% h used to produce xE
equilS.hBarXe = equilS.xe ./ equilS.y_hs;
% h used to produce xS
equilS.hBarXs = equilS.xs ./ equilS.y_hs;
checkLH.approx_equal(equilS.hBarXe + equilS.hBarXs, equilS.hBarS, 1e-5, []);

% h in c sector
equilS.hBarC = equilS.hBar - equilS.hBarS;
validateattributes(equilS.hBarC, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
% Cannot guarantee that this is positive for all param values
equilS.hBarC = max(1e-3, equilS.hBarC);

% output per worker in c sector
equilS.yc = cS.outputTechS.output(countryS.TFP, priceS.kappaC) .* equilS.hBarC;

% output per worker (added missing pS)
equilS.y = equilS.yc + priceS.pS .* equilS.ys;

% School spending / gdp
equilS.sSpendGdp = equilS.xs * priceS.pS / equilS.y;

% Child spending / gdp
equilS.childSpendGdp = equilS.xe * priceS.pE / equilS.y;


%% Not needed for calibration

% Output per worker used for xw
equilS.yW = equil_ms.aggr_xw(hhS.s, hhS.hS, countryS, priceS, paramS, cS);

% Consumption per worker
equilS.consPerWorker = equilS.yc - priceS.pW .* equilS.yW;


end