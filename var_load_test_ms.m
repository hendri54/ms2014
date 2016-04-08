function var_load_test_ms(setNo)

xV = 1 : 10;
varName = 'test1';
var_save_ms(xV, varName, setNo);
x2V = var_load_ms(varName, setNo);
assert(isequal(xV, x2V));

end