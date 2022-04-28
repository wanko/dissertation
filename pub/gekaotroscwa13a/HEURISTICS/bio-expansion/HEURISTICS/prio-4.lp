_heuristic(xreaction(R),false,(A mod 4)+1) :- ireaction(R), reaction(R,A,B), not reaction(R,N), draft(N).

#show _heuristic/3.
#show  xreaction/1.
