function var_save_ms(saveS, varName, setNo)

cS = const_ms(setNo);

save(var_fn_ms(varName, setNo),  'saveS');

end