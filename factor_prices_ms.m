function priceS = factor_prices_ms(TFP, pk, cS)
% Compute wage, pS, pE; given params and TFP, pk
%{
%}

theta = cS.techS.capShare;

pkV = pk .* (cS.tgS.intRate + cS.techS.deltaK);

priceS.kappaC = (TFP .* theta ./ pkV) .^ (1 ./ (1 - theta));

priceS.wage = TFP .* (1 - theta) .* (priceS.kappaC .^ theta); 


%% h technology

pBeta = cS.hTechS.capShare;
priceS.kappaS = pBeta ./ (1 - pBeta) ./ pkV .* priceS.wage;

priceS.pS = pkV ./ TFP ./ pBeta .* (priceS.kappaS .^ (1 - pBeta));
priceS.pE = priceS.pS;

priceS.pW = 1;



end