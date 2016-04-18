function [ys, xs, xe] = s_output_ms(hhS, popGrowth, T, massWorking, cS)
%{
IN:
   hhXe
      household choice of xE

OUT:
   ys
      xe + xs
   xs
      output used for xs(a)
   xe
      output used for xE
%}


% Aggregate xs, p. 2744
xs = integral(@integ_nested, ...
   cS.demogS.startAge, cS.demogS.startAge + hhS.s) / massWorking;

% Aggregate xe (phi(6) makes no sense!)
xe = hhS.xE .* phi_age_ms(cS.demogS.startAge, popGrowth, T) / massWorking;

ys = xe + xs;


%% Nested: integrand
   function outV = integ_nested(ageInV)
      [~, xs_aV] = hhS.spS.age_profile(ageInV - cS.demogS.startAge, hhS.hE, hhS.qE);
      outV = phi_age_ms(ageInV, popGrowth, T) .* xs_aV;
   end
end
