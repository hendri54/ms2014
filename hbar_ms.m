function hBar = hbar_ms(massWorking, h6S, s, countryS, priceS, paramS, cS)
% Average human capital
%{
IN:
   massWorking
      integral of phi(a) over working ages
      p. 2743
%}

numer1 = integral(@(x) integ_hbar(x), cS.demogS.startAge + s, countryS.ageRetire);

hBar = numer1 / massWorking;
validateattributes(hBar, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})


%% Nested: integrand
   function outV = integ_hbar(ageV)
      [haV, naV] = ojt_solve_ms(ageV - s - cS.demogS.ageStart, priceS.wage, priceS.pW, countryS.ageRetire - s, ...
         h6S, paramS, cS);
      phi_aV = phi_age_ms(ageV, countryS.popGrowth, countryS.T);

      outV = haV .* (1 - naV) .* phi_aV;
   end

end