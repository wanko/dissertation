

_heuristic(push(X,e;w,T), level, 0):-  X=1..M,  num_rows(M), T = 1..S, max_steps(S).  
_heuristic(push(Y,s;n,T), level, 0):-  Y=1..M,  num_cols(M), T = 1..S, max_steps(S).
_heuristic(push(X,e;w,T), factor, 1):-  X=1..M,  num_rows(M), T = 1..S, max_steps(S).  
_heuristic(push(Y,s;n,T), factor, 1):-  Y=1..M,  num_cols(M), T = 1..S, max_steps(S).
_heuristic(push(X,e;w,T), init, 0):-  X=1..M,  num_rows(M), T = 1..S, max_steps(S).  
_heuristic(push(Y,s;n,T), init, 0):-  Y=1..M,  num_cols(M), T = 1..S, max_steps(S).


#show _heuristic/3.
