function dev28 = s_dev28(qE, hE, hS, s, priceS, paramS)

c28a = (hE ^ (paramS.gamma-1)) * paramS.zH * ((qE / priceS.pS * paramS.gamma2) ^ paramS.gamma2);
c28 = 1 + (1 - paramS.gamma1) / paramS.mu * (c28a ^ (1/(1-paramS.gamma2))) * (exp(paramS.mu * s) - 1);
dev28 = hS - hE * exp(-paramS.deltaH * s) * (c28 ^ (1 / (1-paramS.gamma1)));
validateattributes(dev28, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

end