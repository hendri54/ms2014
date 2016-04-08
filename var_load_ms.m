function saveS = var_load_ms(varName, setNo)

cS = const_ms(setNo);

load(var_fn_ms(varName, setNo), 'saveS');

end