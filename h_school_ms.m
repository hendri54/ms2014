function hSchoolV = h_school_ms(sV, wage, pW, ageRetireV, paramS, cS)
% Compute h(6+s) implied by MS's tables
%{
IN
   sV
      years of schooling
   wage_pwV
      wage (1-tau) / pW
   ageRetireV
      retirement ages
%}


% p 2756 or (27)
m6S = m_age_ms(6 + sV, ageRetireV, paramS.deltaH, paramS.r);
bTerm = bracket_term_ms(paramS.r, wage, pW, paramS);
% (27)
hSchoolV = (bTerm .* m6S) .^ (1 / (1 - paramS.gamma));

validateattributes(hSchoolV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})


end