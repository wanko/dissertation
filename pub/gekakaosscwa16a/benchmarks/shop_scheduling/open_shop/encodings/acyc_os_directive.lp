#script(python)

def id(x,y):
    return str(x)+'_'+str(y)
    
#end.

seq(@id(T1,M1),@id(T2,M2)):-seq(T1,M1,T2,M2,_),task(T1),task(T2),machine(M1),machine(M2).
seq(T1,T2):-seq(T1,T2,_).       

#edge (T1,T2) : seq(T1,T2).