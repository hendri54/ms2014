function fPath = var_fn_ms(varName, setNo)

cS = const_ms(setNo);

fPath = fullfile(cS.dirS.matDir, [varName,'.mat']);

end