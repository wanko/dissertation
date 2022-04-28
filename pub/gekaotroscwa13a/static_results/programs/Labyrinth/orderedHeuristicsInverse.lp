

_heuristic(push(X,e;w,T), mod, S-T):-  X=1..M,  num_rows(M), T = 1..S, max_steps(S).  
_heuristic(push(Y,s;n,T), mod, S-T):-  Y=1..M,  num_cols(M), T = 1..S, max_steps(S).

#show _heuristic/3.
