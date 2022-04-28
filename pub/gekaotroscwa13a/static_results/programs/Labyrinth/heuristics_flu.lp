
_heuristic(shift(XX,YY,X,Y,T), mod, n) :- neighbor(e;w;n;s,XX,YY,X,Y), max_steps(S), T = 1..S.
_heuristic(connect(X,Y,D,T), mod, n) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), dir(D), max_steps(S), T = 1..S.
_heuristic(goal(X,Y,T), mod, n) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.
_heuristic(reach(X,Y,T), mod, n) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.

#show _heuristic/3.
#show shift/5.
#show connect/4.
#show goal/3.
#show reach/3.