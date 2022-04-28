task(T):-executionTime(T,_,_).
machine(M):-executionTime(_,M,_).

%get maximum timepoint
maxtime(T,T1):-task(T), executionTime(T,R1,T1), 0{executionTime(T,R2,T2):R2!=R1, T2>T1}0. %usually bad encoding, fine in this case since domain predicates only
time(0..Max-1):-Max=#sum{T1,T,R1:executionTime(T,R1,T1)}. %see comment above

task_nr(S):-S=#sum{1,task(T):task(T)}.
1{order(T,S):S=1..Nr,task_nr(Nr)}1:-task(T).
:-not 1{order(T,S)}1, S=1..N,task_nr(N).

next(T1,T2) :- order(T1,S1), order(T2,S1+1).

seq(T,1,0):-task(T).

% place task sequentially on machines
seq(T,M+1,S+Time):-task(T), machine(M), machine(M+1), executionTime(T,M,Time), seq(T,M,S), time(S+Time).

% decide which task first on machine
seq(T2,M,S+Time):-next(T1,T2), machine(M), executionTime(T1,M,Time), seq(T1,M,S), time(S+Time).  

aux(T,M,S)   :- seq(T,M,S).
aux(T,M,S-1) :- aux(T,M,S), time(S-1).

bind(T,M,S) :- aux(T,M,S), not aux(T,M,S+1).

#show bind/3.
#show order/2.