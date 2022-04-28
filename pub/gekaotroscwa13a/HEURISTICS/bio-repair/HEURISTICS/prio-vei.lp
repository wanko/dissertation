_heuristic(repair(ivert(P,V)),false,1)   :- pos(ivert(P,V)).
_heuristic(repair(eflip(U,V,S)),false,2) :- pos(eflip(U,V,S)).
_heuristic(repair(vflip(P,V,S)),false,3) :- pos(vflip(P,V,S)).

#show _heuristic/3.
#show repair/1.
