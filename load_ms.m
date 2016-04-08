function tbM = load_ms(setNo)
% Load result table from MS 2014
%{
OUT
   tbM :: table
      fields: see xlsx file
%}

cS = const_ms(setNo);

tbM = readtable(cS.dirS.resultFile);

tbM.ageRetire = min(tbM.T, cS.demogS.Rmax);

% Population growth rate = fertility / B
tbM.popGrowthRate = log(tbM.demographics) ./ cS.demogS.B;

end