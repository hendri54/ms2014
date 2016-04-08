function maV = m_age_ms(ageV, ageRetireV, deltaH, r)
% m(a)

validateattributes(ageRetireV - ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})

maV = 1 - exp((r + deltaH) .* (ageV - ageRetireV));

end