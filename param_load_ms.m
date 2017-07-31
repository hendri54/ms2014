function paramS = param_load_ms(setNo)
% Load saved parameters

cS = const_ms(setNo);

if exist(var_fn_ms('parameters', setNo), 'file')
   paramS = var_load_ms('parameters', setNo);
else
   paramS = param_set_ms(setNo);
end

paramS = param_derived_ms(paramS, cS);


end