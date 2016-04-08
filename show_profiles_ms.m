function show_profiles_ms(setNo)
% Show age profiles of various variables

cS = const_ms(setNo);
load(fullfile(cS.dirS.matDir, 'hh_solution.mat'), 'saveS');

% Groups to show
ng = 4;
igV = round(linspace(1, cS.nGroups, ng));


%% Show profiles

yLabelV = {'h', 'n', 'xw', 'wage'};

nFig = length(yLabelV);

for iFig = 1 : nFig
   fS = FigureLH('visible', 'on');
   fS.set_defaults;
   fS.new;
   hold on;

   for iLine = 1 : ng
      ig = igV(iLine);
      
      if strcmp(yLabelV{iFig}, 'h')
         yV = saveS.h_agM(:,ig);
      elseif strcmp(yLabelV{iFig}, 'n')
         yV = saveS.n_agM(:,ig);
      elseif strcmp(yLabelV{iFig}, 'xw')
         yV = saveS.xw_agM(:,ig);
      elseif strcmp(yLabelV{iFig}, 'wage')
         yV = log(saveS.wage_agM(:,ig));
      else
         error('Invalid');
      end

      fS.plot_line(saveS.age_agM(:,ig), yV, iLine);
   end
   hold off;

   xlabel('age');
   ylabel(yLabelV{iFig});
   legend(arrayfun(@(x) sprintf('%i', x), igV, 'UniformOutput', false));
   fS.format;
   pause;
   close;
end

end