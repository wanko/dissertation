#script(python)

def id(x,y):
    return str(x)+'_'+str(y)
    
#end.

%two tasks are seq if they are sequential(sic!) or if T2 depends on T1     
direct(@id(T1,M1),@id(T2,M2)) :- seq(T1,M1,T2,M2,_),task(T1),task(T2),machine(M1),machine(M2).
direct(T1,T2) :- seq(T1,T2,_).
direct(@id(T,M1),@id(T,M2)) :- sequence(T,M1,ST), sequence(T,M2,ST+1), executionTime(T,M1,Time).	
depends(@id(T,M1),@id(T,M2)) :- sequence(T,M1,ST), sequence(T,M2,ST+1), executionTime(T,M1,Time).	
depends_trans(T1,T2) :- depends(T1,T2).
depends_trans(T1,T3) :- depends(T2,T3), depends_trans(T1,T2).			

seq(T1,T2) :- direct(T1,T2).
seq(T1,T3) :- seq(T1,T2), direct(T2,T3), not depends_trans(T2,T1), T1!=T2, T2!=T3.
%Cycle check.
:- seq(T,T).
:- depends_trans(T1,T2), seq(T2,T1).