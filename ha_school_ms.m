function hV = ha_school_ms(ageV, hE, qE, priceS, paramS)
% Eqn 22

% check +++++

validateattributes(ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 6})

C2 = (hE .^ (paramS.gamma - 1))  .*  ((qE ./ priceS.pS .* paramS.gamma2) .^ paramS.gamma2)  .*  paramS.zH;
C3 = exp(paramS.mu .* (ageV - 6)) - 1;
C1 = 1 + (1 - paramS.gamma1) ./ paramS.mu .* (C2 .^ (1 / (1-paramS.gamma2))) .* C3;
   
hV = hE .* exp(-paramS.deltaH .* (ageV - 6)) .* (C1 .^ (1 / (1 - paramS.gamma1)));

validateattributes(hV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', size(ageV)})

end