function paramS = param_derived_ms(paramS, cS)

if cS.sameCurvature
   paramS.beta = paramS.gamma;
   paramS.b1b  = paramS.g1g;
end

if cS.sameProductivity
   paramS.zs = paramS.zH;
end



paramS.r = cS.tgS.intRate;

paramS.gamma1 = paramS.g1g * paramS.gamma;
paramS.gamma2 = paramS.gamma - paramS.gamma1;

paramS.beta1 = paramS.b1b * paramS.beta;
paramS.beta2 = paramS.beta - paramS.beta1;

% Growth rate of x during schooling (21)
paramS.g_xs = (paramS.r + paramS.deltaH .* (1 - paramS.gamma1)) ./ (1 - paramS.gamma2);

% p 2759
paramS.mu = (paramS.gamma2 * paramS.r + paramS.deltaH * (1 - paramS.gamma1)) / (1 - paramS.gamma2);

validateattributes(paramS.mu, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})




end