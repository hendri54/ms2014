function tbM = prices_ms(setNo)
% Compute prices and k/h ratios, given parameters
% Does not require solution to hh problem


% update +++++
error(' ');

cS = const_ms(setNo);

% Results from MS
tbM = load_ms(setNo);

theta = cS.techS.capShare;

pkV = tbM.pk .* (cS.tgS.intRate + cS.techS.deltaK);

tbM.kappaC = (tbM.TFP .* cS.techS.capShare ./ pkV) .^ (1 ./ (1 - cS.techS.capShare));

tbM.wage = tbM.TFP .* (1 - theta) .* (tbM.kappaC .^ theta); 

% Check against marginal products +++

pBeta = cS.hTechS.capShare;
tbM.kappaS = pBeta ./ (1 - pBeta) ./ pkV .* tbM.wage;

tbM.pS = pkV ./ tbM.TFP ./ pBeta .* (tbM.kappaS .^ (1 - pBeta));
tbM.pE = tbM.pS;

tbM.pW = ones(cS.nGroups, 1);

% Retirement age
tbM.ageRetire = min(64, tbM.T);

end