_heuristic(xreaction(R),sign,-1) :- ireaction(R), not reaction(R,N), draft(N).
_heuristic(xreaction(R),factor,8) :- ireaction(R), not reaction(R,N), draft(N).

#show _heuristic/3.
#show  xreaction/1.
