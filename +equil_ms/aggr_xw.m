function xw = aggr_xw(s, h6S, countryS, priceS, paramS, cS)
% Compute aggregate xw (goods used in OJT) per worker

massWorking = integral(@(x) phi_age_ms(x, countryS.popGrowth, countryS.T),  6 + s, countryS.ageRetire);
xw = integral(@integ_nested, 6+s, countryS.ageRetire) ./ massWorking;


   %% Nested: integrand
   function outV = integ_nested(ageV)
      [~, ~, xwV] = ojt_solve_ms(ageV, priceS.wage, priceS.pW, countryS.ageRetire, s, h6S, paramS, cS);
      outV = phi_age_ms(ageV, countryS.popGrowth, countryS.T) .* xwV;
   end
end