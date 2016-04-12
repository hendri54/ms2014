classdef OutputTechMs < handle
%{
Production functions: y = z (k/h) ^ theta
%}
   
properties
   theta
   %deltaK
end


methods
   %% Constructor
   function otS = OutputTechMs(theta)
      otS.theta = theta;
      %otS.deltaK = deltaK;
   end
   
   
   %% Marginal products, given TFP and K/H
   function [mpkV, mphV] = marginal_products(otS, z, kappaV)
      mpkV = z .* otS.theta .* (kappaV .^ (otS.theta-1));
      mphV = z .* (1 - otS.theta) .* (kappaV .^ otS.theta);
   end
   
   %% Output per unit of h, given k/h and z
   function y = output(otS, z, kappaV)
      y = z .* (kappaV .^ otS.theta);
   end
end
   
end