#include <incmode>.

#program base.
on(D,P,0) :- init_on(D,P).%%#(\label{fig:toh:enc:static}#)

#program check(t).
:- goal_on(D,P), not on(D,P,t), query(t).%%#(\label{fig:toh:enc:goal}#)


#program step(t).%%#(\label{fig:toh:enc:step:begin}#)
1 { move(D,P,t) : disk(D), peg(P) } 1.

move(D,t)        :- move(D,P,t).
on(D,P,t)        :- move(D,P,t).
on(D,P,t)        :- on(D,P,t-1), not move(D,t).
blocked(D-1,P,t) :- on(D,P,t-1).
blocked(D-1,P,t) :- blocked(D,P,t), disk(D).

:- move(D,P,t), blocked(D-1,P,t).
:- move(D,t), on(D,P,t-1), blocked(D,P,t).
:- disk(D), not 1 { on(D,P,t) } 1.%%#(\label{fig:toh:enc:step:end}#)

#show move/3.
