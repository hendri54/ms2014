function out1 = bracket_term_ms(r, wage, pW, paramS)
% The term that occurs in brackets everywhere

% p 2756 or (27)
c1  = paramS.zH .* (paramS.gamma1 .^ (1 - paramS.gamma2)) .* (paramS.gamma2 .^ paramS.gamma2) ./ (r + paramS.deltaH);
c2  = (wage / pW) .^ paramS.gamma2;
out1 = c1 .* c2;


end