function [ys, xs, xe] = s_output_ms(hhXe, hE, qE, pS, s, popGrowth, T, massWorking, paramS, cS)
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

% xsV = hh_xs_ms(ageV, hE, qE, pS, paramS, cS)

% f_aV = griddedInterpolant(ageV, phi_age_ms(ageV, popGrowth, T) .* xs_aV, 'linear');

% Aggregate xs, p. 2744
xs = integral(@(x) phi_age_ms(x, popGrowth, T) .* hh_xs_ms(x, hE, qE, pS, paramS, cS), 6, 6+s) / massWorking;

% Aggregate xe (phi(6) makes no sense!)
xe = hhXe .* phi_age_ms(6, popGrowth, T) / massWorking;

ys = xe + xs;

end