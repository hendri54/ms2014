function phi_aV = phi_age_ms(ageV, popGrowth, T)
% phi(a) function. Eqn (8)
%{
IN
   T
      life span, NOT retirement age
%}

validateattributes(ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', T})

phi_aV = popGrowth .* exp(-popGrowth .* ageV) ./ (1 - exp(-popGrowth .* T));

end