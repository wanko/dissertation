edge(R,M,N,T) :- reaction(R,T), rct(M,_,R,T), prd(N,_,R,T).
edge(R,M,N,T) :- reaction(R,T), rct(N,_,R,T), prd(M,_,R,T), reversible(R).

scope(M,d) :- metabolite(M,s).
scope(M,d) :- edge(R,_,M,T), T!=r, scope(N,d):edge(R,N,_,T'), N!=M, T'!=r.

scope(M,x) :- scope(M,d). 
scope(M,x) :- edge(R,_,M,_), scope(N,x):edge(R,N,_,_), N!=M.

{ completion(R) : edge(R,M,N,r), scope(N,x), scope(M,x) }.

scope(M,c) :- scope(M,d). 
scope(M,c) :- edge(R,_,M,T), T!=r, scope(N,c):edge(R,N,_,T'), T'!=r, N!=M.
scope(M,c) :- completion(R), edge(R,_,M,r), scope(N,c):edge(R,N,_,r), N!=M.

:- metabolite(M,t), not scope(M,c). 

&dom{L..U} = R :- bounds(R,L,U).

&sum{ IS*IR : prd(M,IS,IR,T), T!=r;  IS'*IR' : prd(M,IS',IR',r), completion(IR');
     -OS*OR : rct(M,OS,OR,T), T!=r; -OS'*OR' : rct(M,OS',OR',r), completion(OR')
    } = "0" :- metabolite(M,_).

&sum{ R } > "0" :- reaction(R,t).

&maximize{   R : objective(R,t) }. 
#minimize{ 1,R : completion(R)  }.

#show completion/1.
