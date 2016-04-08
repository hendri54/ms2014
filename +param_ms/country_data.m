function countryS = country_data(ig, setNo)
% Make a country data structure for a group or for the US
%{
IN
   ig
      group number or 'USA'
%}

cS = const_ms(setNo);

if isnumeric(ig)
   % Load table with data by group (from MS's paper)
   tbM = load_ms(setNo);
   % Country specific parameters
   countryS = CountryParamsMs(tbM.TFP(ig), tbM.pk(ig), tbM.popGrowthRate(ig), tbM.ageRetire(ig), tbM.T(ig));
   
elseif strcmpi(ig, 'USA')
   % Data for US
   popGrowth = cS.tgS.fertility / cS.demogS.B;
   countryS = CountryParamsMs(cS.techS.zUS, cS.tgS.pkUS, popGrowth, cS.demogS.Rmax, cS.demogS.T_US);
else
   error('Invalid');
end


end