function hBar = hbar_ms(massWorking, h6S, s, countryS, priceS, paramS, cS)
% Average human capital
%{
IN:
   massWorking
      integral of phi(a) over working ages
      p. 2743
%}

% Make a continuous approximation of h(a) (1-n(a)) phi(a)
% phi_aV = phi_age_ms(ageV, popGrowth, T);
% f_aV = griddedInterpolant(ageV, h_aV .* (1 - n_aV) .* phi_aV, 'linear');

numer1 = integral(@(x) integ_hbar(x), 6+s, countryS.ageRetire);
% denom1 = integral(@(x) phi_age_ms(x, popGrowth, T),  6+s, ageRetire);

hBar = numer1 / massWorking;
validateattributes(hBar, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})


%% Nested: integrand
   function outV = integ_hbar(ageV)
      [haV, naV] = ojt_solve_ms(ageV, priceS.wage, priceS.pW, countryS.ageRetire, s, h6S, paramS, cS);
      phi_aV = phi_age_ms(ageV, countryS.popGrowth, countryS.T);

      outV = haV .* (1 - naV) .* phi_aV;
   end

end