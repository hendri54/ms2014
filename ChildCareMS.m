% Child care problem
%{
%}
classdef ChildCareMS < handle
   
properties
   % Endowment at birth
   hB double
   % Price of input
   pE double
   % Curvature
   v double
end


methods
   %% Constructor
   function ccS = ChildCareMS(hB, pE, v)
      ccS.hB = hB;
      ccS.pE = pE;
      ccS.v = v;
   end
   
   
   %% Technology
   % (3) in MS 2014
   function hE = he_produced(ccS, xE)
      hE = ccS.hB .* (xE .^ ccS.v);
   end
   
   
   %% Solve for given qE = q(6)
   % (29) in MS 2014
   function [hE, xE] = solve_given_qe(ccS, qE)
      xE = (ccS.v .* qE .* ccS.hB ./ ccS.pE) .^ (1 ./ (1 - ccS.v));
      hE = ccS.he_produced(xE);
   end
   
   
   %% Value
   % Eqn before (30) in MS2014
   function vOutV = value(ccS, qE, xEV)
      vOutV = qE .* ccS.he_produced(xEV) - ccS.pE .* xEV;
   end
   
end
   
   
end