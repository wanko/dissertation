% initial situation
on(D,P,0) :- init_on(D,P).%%#(\label{fig:toh:opt:enc:init}#)

% check goal situation
ngoal(T) :- on(D,P,T), not goal_on(D,P).%%#(\label{fig:toh:opt:enc:goal:begin}#)
:- ngoal(n).%%#(\label{fig:toh:opt:enc:goal:end}#)

% state transition and state constraints
1 { move(D,P,T) : disk(D), peg(P) } 1 :- ngoal(T-1), T<=n.%%#(\label{fig:toh:opt:enc:trans:begin} \label{fig:toh:opt:enc:move}#)

move(D,T)        :- move(D,P,T).
on(D,P,T)        :- move(D,P,T).
on(D,P,T)        :- on(D,P,T-1), not move(D,T), T<=n.
blocked(D-1,P,T) :- on(D,P,T-1).
blocked(D-1,P,T) :- blocked(D,P,T), disk(D).

:- move(D,P,T), blocked(D-1,P,T).
:- move(D,T), on(D,P,T-1), blocked(D,P,T).
:- disk(D), not 1 { on(D,P,T) } 1, T=1..n.%%#(\label{fig:toh:opt:enc:trans:end}#)

#show move/3.

_minimize(1,T) :- ngoal(T).%%#(\label{fig:toh:opt:enc:minimize}#)
