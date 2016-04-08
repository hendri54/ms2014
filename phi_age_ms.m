function phi_aV = phi_age_ms(ageV, popGrowth, T)
% phi(a) function. Eqn (8)

phi_aV = popGrowth .* exp(-popGrowth .* ageV) ./ (1 - exp(-popGrowth .* T));

end