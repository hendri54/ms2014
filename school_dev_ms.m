function devV = school_dev_ms(hE, hS, s, qE, ageRetire, priceS, paramS, cS)
% Deviations from optimality conditions for school / child care phase
%{
IN
   hE, hS, s, qE
      same notation as in paper
      hS = h(6+s)
%}

% (27)
hS27 = school_ms.h_school(s, priceS.wage, priceS.pW, ageRetire, paramS, cS);
dev27 = hS27 - hS;

% (26)
dev26 = eqn_ms.s_dev26(qE, hE, s, ageRetire, priceS, paramS);

% (29)
dev29 = eqn_ms.s_dev29(qE, hE, priceS, paramS, cS);

% (28)
dev28 = eqn_ms.s_dev28(qE, hE, hS, s, priceS, paramS);

devV = [dev26, dev27, dev28, dev29];
validateattributes(devV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [1,4]})

   
end