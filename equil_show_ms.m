function equil_show_ms(countryS, setNo)
% Show equilibrium
%{
IN
   outS
      output of equilibrium_ms
%}

saveFigures = 1;

cS = const_ms(setNo);
paramS = param_load_ms(setNo);

outS = equilibrium_ms(countryS, paramS, cS);

equilS = outS.equilS;

fprintf('y = %.2f    xS/y = %.2f    xE/y = %.2f    xW/y = %.2f \n', ...
   equilS.y,    equilS.sSpendGdp,  equilS.childSpendGdp,    outS.priceS.pW .* equilS.yW ./ equilS.y);
fprintf('hBarS/hBar = %.2f    hBarC/hBar = %.2f    hBar: %.2f \n', ...
   equilS.hBarS / equilS.hBar,  equilS.hBarC / equilS.hBar, equilS.hBar);

fprintf('s = %.2f    h(6+s) = %.2f    hE = %.2f \n', ...
   outS.hhS.s,  outS.hhS.hS,  outS.hhS.hE);


%% Wage profile

hhS = outS.hhS;

fS = FigureLH('visible', true);
fS.new;

fS.plot_line(hhS.experV + cS.demogS.startAge + hhS.s, hhS.wageV, 1);
xlabel('Age');
ylabel('Wage');

fS.format;
fS.save(fullfile(cS.dirS.outDir, 'wage_profile'), saveFigures);


%% Time investment profile

fS = FigureLH('visible', true);
fS.new;

fS.plot_line(hhS.experV + cS.demogS.startAge + hhS.s, hhS.n_aV, 1);
xlabel('Age');
ylabel('n');

fS.format;
fS.save(fullfile(cS.dirS.outDir, 'n_profile'), saveFigures);




end