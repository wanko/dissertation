% branch on fluent literals backwards
_heuristic(holds(F,T),true,lasttime-T+1) :- holds(F,T1), next(T,T1).
_heuristic(holds(F,T),false,lasttime-T+1) :- not holds(F,T1), predicate(F), next(T,T1).
#show holds/2.
#show _heuristic/3.

