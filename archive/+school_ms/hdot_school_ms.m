function hDotV = hdot_school_ms(ageV, h_aV, hE, qE, priceS, paramS)
% hDot in school. p 2758

C1 = (hE .^ (paramS.gamma1 .* paramS.gamma2)) .* ((qE / priceS.pS .* paramS.gamma2) .^ paramS.gamma2)  .*  ...
   paramS.zH;
C3 = paramS.gamma2 .* (paramS.r + paramS.deltaH .* (1 - paramS.gamma1)) ./ (1 - paramS.gamma2);
C2 = exp(C3 .* (ageV - 6));
hDotV = (C1 .^ (1 / (1 - paramS.gamma2)))  .*  C2  .*  (h_aV .^ paramS.gamma1) - ...
   paramS.deltaH .* h_aV;

validateattributes(hDotV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(h_aV)})

end