function tests = OutputTechMsTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   theta = 0.7;
   z = 1.3;
   kV = linspace(2, 3, 10);
   hV = linspace(0.8, 0.2, 10);
   kappaV = kV ./ hV;
   
   otS = OutputTechMs(theta);
   
   % Output
   yV = otS.output(z, kappaV) .* hV;
   
   % Marginal products
   [mpkV, mphV] = otS.marginal_products(z, kappaV);
   
   testCase.verifyEqual(yV,  mpkV .* kV + mphV .* hV,  'RelTol',  1e-4);
   
   dk = 1e-5;
   y2V = otS.output(z, (kV + dk) ./ hV) .* hV;
   mpk2V = (y2V - yV) ./ dk;
   testCase.verifyEqual(mpk2V, mpkV,  'RelTol', 1e-4);


   dh = 1e-5;
   y2V = otS.output(z, kV ./ (hV + dh)) .* (hV + dh);
   mph2V = (y2V - yV) ./ dk;
   testCase.verifyEqual(mph2V, mphV,  'RelTol', 1e-4);
end