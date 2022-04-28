metabolite("S1",s). metabolite("S2",s). metabolite("S3",s).
metabolite("a",t).  metabolite("b",d).  metabolite("c",t).
metabolite("d",d).  metabolite("e",d).  metabolite("f",d).
metabolite("g",r).

reaction("R_importS1",s).     reaction("R_importS2",s).
reversible("R_importS1").     reversible("R_importS2").
prd("S1","1","R_importS1",s). prd("S2","1","R_importS2",s).
reaction("R_exportF",d).      rct("f","1","R_exportF",d).

reaction("R0",d).      reaction("R1",d).
rct("b","1","R0",d).   rct("S3","1","R1",d).
prd("S3","1","R0",d).  prd("b","1","R1",d).

reaction("R2",d).      reaction("R3",d).
rct("c","1","R2",d).   rct("d","1","R3",d).
rct("S2","1","R2",d).  prd("e","1","R3",d).
prd("d","1","R2",d).

reaction("R4",d).      reaction("R9",r).
rct("e","1","R4",d).   rct("g","1","R9",r).
prd("c","2","R4",d).   prd("f","1","R9",r).

reaction("R5",t).      reaction("R6",r).
rct("a","1","R5",t).   rct("S1","1","R6",r).
rct("c","1","R5",t).   prd("a","1","R6",r).
prd("f","1","R5",t).   prd("g","1","R6",r).

reaction("R7",r).      reaction("R8",r).
rct("S3","1","R7",r).  rct("b","1","R8",r).
prd("e","1","R7",r).   prd("e","1","R8",r).

objective(R,T) :- reaction(R,T), T!=t.
objective(R,t) :- reaction(R,t).

bounds(R,"0","99999") :- reaction(R,_), not reversible(R).
bounds(R,"-99999","99999") :- reaction(R,_), reversible(R).
