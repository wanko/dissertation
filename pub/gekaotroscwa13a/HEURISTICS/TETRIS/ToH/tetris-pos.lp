% heuristic
_heuristic(on(T-1,N1,N),true,S-T+10)  :- on(T,N1,N), T>0, steps(S).
#show _heuristic/3.
#show on/3.
