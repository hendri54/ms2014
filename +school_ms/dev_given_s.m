function [dev28, hE, qE, xE, hS] = dev_given_s(s, ageRetire, priceS, paramS, cS)
% Deviations from schooling conditions for given s

% h(s) from (27)
hS = school_ms.h_school(s, priceS.wage, priceS.pW, ageRetire, paramS, cS);

% qE hE^g1 from (26)
qEhEG1 = school_ms.qe_he_from26(s, ageRetire, priceS, paramS);

%% hE from (29)

C1 = (paramS.v ./ priceS.pE .* qEhEG1) .^ (paramS.v / (1 - paramS.v)) .* (cS.hTechS.hB .^ (1 / (1 - paramS.v)));
hE = C1 .^ (1 ./ (1 + paramS.gamma1 .* paramS.v ./ (1 - paramS.v)));

qE = qEhEG1 ./ (hE ^ paramS.gamma1);

% Check against (29)
dev29 = eqn_ms.s_dev29(qE, hE, priceS, paramS, cS);
assert(abs(dev29) < 1e-5);


% From (3)
xE = (hE / cS.hTechS.hB) .^ (1 / paramS.v);



%% Out: deviation from (28)

dev28 = eqn_ms.s_dev28(qE, hE, hS, s, priceS, paramS);
validateattributes(dev28, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   

end