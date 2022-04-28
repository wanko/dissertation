#domain time(T).
#domain time(T1).
time(0..lasttime).
next(T,T1) :- T1 = T + 1.

% fluents for sat planning
fluent(F) :- init(F). fluent(F) :- adds(A,F).
{ holds(F,T) } :- fluent(F), T > 0.

% non concurrent actions
0 { apply(A,T) : action(A) } 1 :- T!=lasttime.

% initial situation
holds(F,0) :- init(F).

% actions preconditions
:- not holds(F,T), apply(A,T), demands(A,F,true).
:- holds(F,T), apply(A,T),    demands(A,F,false).

% actions direct effects
:- not holds(F,T1), apply(A,T), adds(A,F), next(T,T1).
:- holds(F,T1), apply(A,T), deletes(A,F),  next(T,T1).

% inertia
:- holds(F,T1), not holds(F,T), not apply(A,T) : adds(A,F),    next(T,T1).
:- not holds(F,T1), holds(F,T), not apply(A,T) : deletes(A,F), next(T,T1).

% final situation
:- not holds(F,lasttime), goal(F,true).
:- holds(F,lasttime),  goal(F,false).

% display
#hide.
#show apply/2.


