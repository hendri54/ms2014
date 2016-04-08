function equil_vary_params(saveFigures, setNo)
% Plot how equilibrium properties vary with TFP
%{
Requires saved calibration
%}


cS = const_ms(setNo);
paramS = param_load_ms(setNo);

% Compute US equilibrium
countryS = param_ms.country_data('USA', setNo);
% equilUS = equilibrium_ms(countryS, paramS, cS);
% yUS = equilUS.equilS.y;


%% Vary tfp

n = 10;
tfpV = linspace(0.7, 1, n)' .* cS.techS.zUS;

yV = zeros(n, 1);
sV = zeros(n, 1);
for i1 = 1 : n
   countryS.TFP = tfpV(i1);
   equilS = equilibrium_ms(countryS, paramS, cS);
   yV(i1) = equilS.equilS.y;
   sV(i1) = equilS.hhS.s;
end

ylabelV = {'log y', 's'};
fileNameStrV = {'logy', 'school'};

for iPlot = 1 : length(ylabelV)
   if strcmpi(ylabelV{iPlot}, 'log y')
      yPlotV = log(yV);
   elseif strcmpi(ylabelV{iPlot}, 's')
      yPlotV = sV;
   else
      error('Invalid');
   end
   
   fS = FigureLH('visible', saveFigures == 0);
   fS.new;
   fS.plot_line(log(tfpV),  yPlotV, 1);
   xlabel('log TFP');
   ylabel(ylabelV{iPlot});
   fS.format;
   fS.save(fullfile(cS.dirS.outDir, [fileNameStrV{iPlot}, '_vary_tfp']), saveFigures);
end

end