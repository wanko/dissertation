#include "dl_lang.lp".

task(T):-executionTime(T,_,_).
machine(M):-executionTime(_,M,_).

% place task in requiered sequence on machines
seq((T,M1),(T,M2),Time):-sequence(T,M1,ST), sequence(T,M2,ST+1), executionTime(T,M1,Time).

% decide which task first on machine
{seq((T1,M),(T2,M),Time1)} :-sequence(T1,M,ST1), sequence(T2,M,ST2), T1<T2, executionTime(T1,M,Time1), executionTime(T2,M,Time2).
seq((T2,M),(T1,M),Time2) :-sequence(T1,M,ST1), sequence(T2,M,ST2), T1<T2, executionTime(T1,M,Time1), executionTime(T2,M,Time2), not seq((T1,M),(T2,M),Time1).

:- not &diff{T1-T2}<= -Time, seq(T1,T2,Time).   

&show_assignment{}.    
#show.    