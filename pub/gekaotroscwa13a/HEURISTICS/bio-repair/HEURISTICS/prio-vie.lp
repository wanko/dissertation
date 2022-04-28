_heuristic(repair(ivert(P,V)),false,2)   :- pos(ivert(P,V)).
_heuristic(repair(eflip(U,V,S)),false,1) :- pos(eflip(U,V,S)).
_heuristic(repair(vflip(P,V,S)),false,3) :- pos(vflip(P,V,S)).

#show _heuristic/3.
#show repair/1.
