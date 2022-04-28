% inputs from the met_net
% species(Species).
% reaction(Reaction,Network).
% reactant(Species,Reaction).
% product(Species,Reaction).
% seed(Species).
% target(Species).

% repair
% choose interesting reactions to extend the network.
% dont extend with already existing reactions.

  { xreaction(R) : ireaction(R) : draft(N) : not reaction(R,N) }.


% optimizations

#minimize { xreaction(R) : ireaction(R) : not reaction(R,N) : draft(N) }.


#hide.
#show xreaction/1.
