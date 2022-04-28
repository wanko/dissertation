% branch on true actions forward
_heuristic(apply(A,T),true,lasttime-T+1) :- action(A), time(T).
#show apply/2.
#show _heuristic/3.

