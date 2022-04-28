% branch on true actions that cause current changes
_heuristic(apply(A,T),true,lasttime-T+1) :- not holds(F,T), holds(F,T1), adds(A,F), next(T,T1).
_heuristic(apply(A,T),true,lasttime-T+1) :- holds(F,T), not holds(F,T1), deletes(A,F), next(T,T1).
#show apply/2.
#show _heuristic/3.

