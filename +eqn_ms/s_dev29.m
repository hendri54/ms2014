function dev29 = s_dev29(qE, hE, priceS, paramS, cS)

v = paramS.v;
dev29 = hE - ((v * qE / priceS.pE) .^ (v / (1-v)))  *  (cS.hTechS.hB ^ (1/(1-v)));
validateattributes(dev29, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

end
