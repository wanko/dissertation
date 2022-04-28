#script(python)

def id(x,y):
    return str(x)+'_'+str(y)
    
#end.

%two tasks are seq if they are sequential(sic!) or if T2 depends on T1     
direct(@id(T1,M1),@id(T2,M2)) :- seq(T1,M1,T2,M2,_),task(T1),task(T2),machine(M1),machine(M2).
direct(T1,T2) :- seq(T1,T2,_).			

seq(T1,T2) :- direct(T1,T2).
seq(T1,T3) :- seq(T1,T2), direct(T2,T3), T1!=T2, T2!=T3.
%Cycle check.
:- seq(T,T).