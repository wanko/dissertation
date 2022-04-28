% inputs from the met_net
% species(Species).
% reaction(Reaction,Network).
% reactant(Species,Reaction).
% product(Species,Reaction).
% seed(Species).
% target(Species).


% what is producible by the original network

  dscope(M) :- seed(M).

  dscope(M) :- product(M,R), reaction(R,N),draft(N),
               dscope(M2) : reactant(M2,R).


% what is producible with all reactions

  pscope(M) :- seed(M).

  pscope(M) :- product(M,R), reaction(R,N),
               pscope(M2) : reactant(M2,R).


% what are the interesting reactions

  interesting(M) :- target(M), not dscope(M).

  interesting(M) :- reactant(M,R), ireaction(R), not dscope(M).

  ireaction(R) :- interesting(M), product(M,R), reaction(R,N).


% repair
% choose interesting reactions to extend the network.
% dont extend with already existing reactions.

  { xreaction(R) : ireaction(R) : draft(N) : not reaction(R,N) }.


% operable reactions
% keine xreaction wenn nicht alle reactants xscope

  oreaction(R) :- xscope(M2) : reactant(M2,R), reaction(R,N), not draft(N).

  :- xreaction(R), not oreaction(R).


% what is producible with the extensions

  xscope(M) :- seed(M).

  xscope(M) :- product(M,R), reaction(R,N), draft(N),
               xscope(M2) : reactant(M2,R).

  xscope(M) :- product(M,R), xreaction(R),
               xscope(M2) : reactant(M2,R).


% every target that is potentially producible must be producible with the extension

  :- target(M), pscope(M), not xscope(M).


% optimizations

#minimize { xreaction(R) : ireaction(R) : not reaction(R,N) : draft(N) }.


#hide.
#show xreaction/1.
