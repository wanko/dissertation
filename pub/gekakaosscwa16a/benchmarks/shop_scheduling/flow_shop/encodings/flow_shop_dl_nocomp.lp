#include "dl_lang.lp".

task(T):-executionTime(T,_,_).
machine(M):-executionTime(_,M,_).

task_nr(S):-S=#sum{1,task(T):task(T)}.
1{order(T,S):S=1..Nr,task_nr(Nr)}1:-task(T).
:-not 1{order(T,S)}1, S=1..N,task_nr(N).

% place task sequentially on machines
seq((T,M),(T,M+1),Time):-task(T), machine(M), machine(M+1), executionTime(T,M,Time).

% decide which task first on machine
seq((T1,M),(T2,M),Time1):-order(T1,S1), order(T2,S1+1), T1!=T2, machine(M), executionTime(T1,M,Time1), executionTime(T2,M,Time2).     

:- not &diff{T1-T2}<= -Time, seq(T1,T2,Time).

&show_assignment{}.   
#show order/2.     