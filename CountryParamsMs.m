classdef CountryParamsMs < handle
% Country specific parameters

properties
   TFP   double
   % Life span
   T  double
   % Retirement age
   ageRetire   double
   pk    double
   popGrowth   double
end


methods
   %% Constructor
   function cpS = CountryParamsMs(TFP, pk, popGrowth, ageRetire, T)
      cpS.TFP = TFP; 
      cpS.pk = pk;
      cpS.popGrowth = popGrowth;
      cpS.ageRetire = ageRetire;
      cpS.T = T;
   end
end
   
   
end