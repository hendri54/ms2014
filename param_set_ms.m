function paramS = param_set_ms(setNo)
% Set parameter guesses (from MS)

cS = const_ms(setNo);
paramS.setNo = setNo;

paramS = struct_update(cS.pvector, paramS, 1);


end