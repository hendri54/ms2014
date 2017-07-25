function tests = var_load_ms_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   xV = 1 : 10;
   setNo = 2;
   varName = 'test1';
   var_save_ms(xV, varName, setNo);
   x2V = var_load_ms(varName, setNo);
   assert(isequal(xV, x2V));
end
