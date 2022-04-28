_heuristic(xreaction(R),false,(A mod 16)+1) :- ireaction(R), reaction(R,A,B), not reaction(R,N), draft(N).

#show _heuristic/3.
#show  xreaction/1.
