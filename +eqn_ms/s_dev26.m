function dev26 = s_dev26(qE, hE, s, ageRetire, priceS, paramS)
% Eqn 26)

rdh = paramS.r + paramS.deltaH;
m6S = m_age_ms(6+s, ageRetire, paramS.deltaH, paramS.r);
bTerm = bracket_term_ms(paramS.r, priceS.wage, priceS.pW, paramS);


lhs = m6S ./ rdh;

C1 = exp((paramS.r + paramS.deltaH * (1 - paramS.gamma1)) * s);

rhs = qE .* (hE .^ paramS.gamma1) ./ priceS.wage .* C1 ./ ((bTerm .* m6S) .^ (paramS.gamma1 ./ (1 - paramS.gamma)));

dev26 = lhs  -  rhs;
validateattributes(dev26, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})

end
