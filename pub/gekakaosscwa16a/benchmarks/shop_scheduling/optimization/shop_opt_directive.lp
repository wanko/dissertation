%get latency (maximum occupied)
aux(Time+Exec):-bind(T,M,Time), executionTime(T,M,Exec). %MAX by MAX
aux(T-1):-aux(T),T>0.
latency(T):-aux(T), not aux(T+1).

#minimize{T:latency(T)}.

#show latency/1.