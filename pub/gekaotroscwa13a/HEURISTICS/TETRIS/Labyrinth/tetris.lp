
_heuristic(shift(XX,YY,X,Y,T-1),true,S-T+1) :- shift(XX,YY,X,Y,T), neighbor(e;w;n;s,XX,YY,X,Y), max_steps(S), T = 1..S.
_heuristic(connect(X,Y,D,T-1),true,S-T+1)   :- connect(X,Y,D,T),   Y=1..M,  num_cols(M), X=1..N,  num_rows(N), dir(D), max_steps(S), T = 1..S.
_heuristic(goal(X,Y,T-1),true,S-T+1)        :- goal(X,Y,T),        Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.
_heuristic(reach(X,Y,T-1),true,S-T+1)       :- reach(X,Y,T),       Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.

_heuristic(shift(XX,YY,X,Y,T-1),false,S-T+1) :- not shift(XX,YY,X,Y,T), neighbor(e;w;n;s,XX,YY,X,Y), max_steps(S), T = 1..S.
_heuristic(connect(X,Y,D,T-1),false,S-T+1)   :- not connect(X,Y,D,T),   Y=1..M,  num_cols(M), X=1..N,  num_rows(N), dir(D), max_steps(S), T = 1..S.
_heuristic(goal(X,Y,T-1),false,S-T+1)        :- not goal(X,Y,T),        Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.
_heuristic(reach(X,Y,T-1),false,S-T+1)       :- not reach(X,Y,T),       Y=1..M,  num_cols(M), X=1..N,  num_rows(N), max_steps(S), T = 1..S.

#show _heuristic/3.
#show shift/5.
#show connect/4.
#show goal/3.
#show reach/3.
