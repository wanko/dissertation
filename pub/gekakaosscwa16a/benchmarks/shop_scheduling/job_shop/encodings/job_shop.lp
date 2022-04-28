task(T):-executionTime(T,_,_).
machine(M):-executionTime(_,M,_).

%get maximum timepoint
maxtime(T,T1):-task(T), executionTime(T,R1,T1), 0{executionTime(T,R2,T2):R2!=R1, T2>T1}0. %usually bad encoding, fine in this case since domain predicates only
time(0..Max-1):-Max=#sum{T1,T,R1:executionTime(T,R1,T1)}. %see comment above

{ before(T1,T2,M) } :- sequence(T1,M,ST1), sequence(T2,M,ST2), T1<T2.
before(T2,T1,M) :- sequence(T1,M,ST1), sequence(T2,M,ST2), T1<T2, not before(T1,T2,M).

seq(T,M,0) :- sequence(T,M,1).

seq(T,M2,S+Time) :- sequence(T,M1,ST), sequence(T,M2,ST+1), executionTime(T,M1,Time), seq(T,M1,S), time(S+Time).
seq(T2,M,S+Time) :- before(T1,T2,M), executionTime(T1,M,Time), seq(T1,M,S), time(S+Time).
:- before(T1,T2,M), executionTime(T1,M,Time), seq(T1,M,S), not time(S+Time).

aux(T,M,S)   :- seq(T,M,S).
aux(T,M,S-1) :- aux(T,M,S), time(S-1).     

bind(T,M,S) :- aux(T,M,S), not aux(T,M,S+1).

#show bind/3.