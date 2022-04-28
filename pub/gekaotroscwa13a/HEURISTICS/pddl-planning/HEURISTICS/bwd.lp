% branch on true actions backward
_heuristic(apply(A,T),true,T+1) :- action(A), time(T).
#show apply/2.
#show _heuristic/3.

