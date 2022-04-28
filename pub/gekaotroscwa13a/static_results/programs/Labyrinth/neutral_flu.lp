
_heuristic(shift(XX,YY,X,Y,T), level, 0) :- neighbor(e;w;n;s,XX,YY,X,Y), max_steps(S), T = 1..S.
_heuristic(connect(X,Y,D,T), level, 0) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), dir(D), max_steps(S), T = 1..S.
_heuristic(goal(X,Y,T), level, 0) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.
_heuristic(reach(X,Y,T), level, 0) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.
_heuristic(shift(XX,YY,X,Y,T), factor, 1) :- neighbor(e;w;n;s,XX,YY,X,Y), max_steps(S), T = 1..S.
_heuristic(connect(X,Y,D,T), factor, 1) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), dir(D), max_steps(S), T = 1..S.
_heuristic(goal(X,Y,T), factor, 1) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.
_heuristic(reach(X,Y,T), factor, 1) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.
_heuristic(shift(XX,YY,X,Y,T), init, 0) :- neighbor(e;w;n;s,XX,YY,X,Y), max_steps(S), T = 1..S.
_heuristic(connect(X,Y,D,T), init, 0) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), dir(D), max_steps(S), T = 1..S.
_heuristic(goal(X,Y,T), init, 0) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.
_heuristic(reach(X,Y,T), init, 0) :- Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.

#show _heuristic/3.
#show shift/5.
#show connect/4.
#show goal/3.
#show reach/3.
