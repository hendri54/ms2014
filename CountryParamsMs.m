classdef CountryParamsMs
% Country specific parameters

properties
   TFP
   T
   ageRetire
   pk
   popGrowth
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