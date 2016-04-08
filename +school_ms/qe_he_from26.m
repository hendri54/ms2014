function out1 = qe_he_from26(s, ageRetire, priceS, paramS)
% Eqn (26): solve for qE hE^gamma1

rdh = paramS.r + paramS.deltaH;
m6S = m_age_ms(6+s, ageRetire, paramS.deltaH, paramS.r);
bTerm = bracket_term_ms(paramS.r, priceS.wage, priceS.pW, paramS);

C1 = exp((paramS.r + paramS.deltaH * (1 - paramS.gamma1)) * s);
out1 = m6S ./ rdh .* ((bTerm .* m6S) .^ (paramS.gamma1 ./ (1 - paramS.gamma))) .* priceS.wage ./ C1;

validateattributes(out1, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})

end
