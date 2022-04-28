
================================================================================================
										HCLASP README
================================================================================================


Hclasp allows to modify the vsids heuristic of clasp by means of ASP code.

To use hclasp the command line option --heu=domain must be used,
otherwise clasp will run normally.
Example: 
  $gringo example.lp | clasp --heu=domain
  
Clasp vsids heuristic works as follows:
- For each variable v an activity a(v) is maintained 
  that is initially set to the MOMS-score (a number between 0 and 1) of the variable.
- During conflict analysis: For each variable v contained in a constraint CL that
  participates in the derivation of the asserting clause, a(v) is incremented by 1.
- When a decision is necessary a free variable with the highest activity is taken
  and from this variable the literal that occured in more learnt clauses is picked.
  (if there is a tie then the preferred choice literal of v is selected: v for bodies, ~v for heads).

Hclasp allows to modify the vsids behavior statically (i.e., before starting the search), 
or dinamycally (i.e., during the search, depending on the current partial assignment).

Note: 
  For hclasp to run properly, atoms of the form _heuristic/3 must appear in the input symbol table
  (and the same holds for the atoms that appear as terms inside the _heuristic atoms.
  In short, #show all _heuristic atoms, and also #show the atoms inside those atoms) 

Hclasp allows to compute one or many subset minimal answer sets (see at the bottom).
  
 hclasp modifiers
ииииииииииииииииии

Initial Activity: 
  
  _heuristic(V,init,X)
  
  Add X to the initial MOMS-score of variable V.
  
  Example sentence: 
    _heuristic(a,init,2).
	

Factor:

  _heuristic(V,factor,X)
  
  During conflict analysis if variable V is updated then increment its activity by X.

  Example sentence: 
    _heuristic(holds(on,3),factor,3).

	  
Sign:
  
  _heuristic(V,sign,X)

  The preferred choice literal for V is V if X>0, ~V if X<0, 
  and clasp chooses normally if X=0.
     
	  sign.lp:
		{a}.
		_heuristic(a,sign,-1).
	 
	  Execution: 
		$gringo sign.lp | hclasp --heu=domain
		Answer: _heuristic(a,sign,-1)
	   
	  sign2.lp:
		{a}.
		_heuristic(a,sign,1).
	 
	  Execution: 
		$gringo sign2.lp | hclasp --heu=domain
		Answer: _heuristic(a,sign,1) a
   
  
Level:

  _heuristic(V,level,X).
  
  Variable V is assigned level X (an integer).
  In hclasp variables have a level (0 by default).
  hclasp chooses a free variable of the highest level, 
  and if there are many of these, it chooses the one with the highest activity.
  
  Example sentence: _heuristic(a,level,10).
  

Level-Sign:

  _heuristic(V,true,X) 
  
  Variable V is assigned level X (an integer) and the preferred choice literal for V is V.
  Equivalent to:
    _heuristic(V,level,X).
    _heuristic(V,sign,1).
  
	  true.lp:
		{a,b}. 
		:- a,b.
		_heuristic(a,true,1).
		
	  Execution:
		$gringo true.lp | hclasp --heu=domain
		Answer: _heuristic(a,true,1). a.
	  
	  true2.lp:
		{a,b}. 
		:- a,b.
		_heuristic(a,true,1). _heuristic(b,true,10).
		
	  Execution:
		$gringo true2.lp | hclasp --heu=domain
		Answer: _heuristic(a,true,1). _heuristic(b,true,10). b.
  
  _heuristic(V,false,X) 
  
  Variable V is assigned level X (an integer) and the preferred choice literal for V is ~V.
  Equivalent to:
    _heuristic(V,level,X).
    _heuristic(V,sign,-1).
  
	  false.lp:
		{a,b}. 
		:- not a, not b.
		_heuristic(a,false,1). _heuristic(b,false,5).
		
	  Execution:
		$gringo false.lp | hclasp --heu=domain
		Answer: _heuristic(a,false,1). _heuristic(b,false,5). a.
  
 
Other examples:
 
  Branch first on actions if possible:
    _heuristic(apply(A,T),level,1) :- action(A), time(T).
 
  Branch first on actions of the latest situations if possible:
    _heuristic(apply(A,T),level,T) :- action(A), time(T).
 
  For subset minimization of actions in planning, use: 
    _heuristic(apply(A,T),false,1) :- action(A), time(T).
  
  For subset minimization of faults in Reiter-style diagnosis, use: 
    _heuristic(ab(C),false,1) :- component(C).
     
  For subset minimization of faults in diagnosis, 
  minimizing first faults in set type1 and afterwards the others, use:
    _heuristic(ab(C),false,2) :- component(C), type1(C).    
	_heuristic(ab(C),false,1) :- component(C), not type1(C). 
  
  Note: instead of 2 and 1 we could have used any to integers X and Y such that X>Y>0.
        
      
Dynamic modifications
иииииииииииииииииииии  

  _heuristic atoms for sign, factor and level may be used dynamically, 
  so that the modification of the values is made during the search, 
  when the heuristic atom becomes true.
 
  program: {a}.  _heuristic(a,true,10).
  Answer: a 
  [ hclasp branches on a ]
  
  program:  {a}.  _heuristic(a,false,10).
  Answer: 
  [ hclasp branches on ~a ]
  
  program:  {a}.  _heuristic(a,false,10). _heuristic(a,true,5).
  Answer: 
  [ if there are two heuristic atoms true for one variable, hclasp prefers the one with higuest priority ]
  
  program:  {a}.  _heuristic(a,false,10). _heuristic(a,true,50).
  Answer: a
  
  program: {a,b}. _heuristic(a,true,100). _heuristic(b,true,50). _heuristic(b,false,10).
  Answer: a b
  [ hclasp branches first on a and then on b ]
  
  program: {a,b}. _heuristic(a,true,100). _heuristic(b,true,50) :- not a. _heuristic(b,false,10).
  Answer: a
  [ hclasp branches first on a, _heuristic(b,true,50) is *not* true in the assignment, 
    and given thar _heuristic(b,false,10) is true, hclasp branches on ~b  ]
  
  program: {a,b}. _heuristic(a,false,100). _heuristic(b,true,50) :- not a. _heuristic(b,false,10).
  Answer: b
  [ hclasp branches first on ~a, _heuristic(b,true,50) is true and then hclasp branches on b ]

  Planning heuristics examples:
 
    Branch on actions when they are possible given the current partial assignment:
	  _heuristic(apply(A,T),true,1) :- poss(A,T).
	  
    Branch on actions of type1 and then on others when they are possible:
	  _heuristic(apply(A,T),true,10) :- poss(A,T), type1(A).
	  _heuristic(apply(A,T),true,4)  :- poss(A,T), not type1(A).
	  
	Make fluents persist backwards:
	  _heuristic(holds(F,T-1),true,1) :- holds(F,T).
	  _heuristic(holds(F,T-1),false,1) :- not holds(F,T).
	  
	Make fluents persist backwards, and branch first on earlier fluents:
	  _heuristic(holds(F,T-1),true,lasttime-T) :- holds(F,T).
	  _heuristic(holds(F,T-1),false,lasttime-T) :- not holds(F,T).
	  
	  
Priorities in heuristic atoms
иииииииииииииииииииииииииииии  

To stablish priorities between heuristic atoms for the same variable, 
we add a fourth term to the heuristic predicate:

	_heuristic(Atom,Modifier,Value,Priority).

so that if we have:

	_heuristic(Atom,Modifier,Value1,0). 
	_heuristic(Atom,Modifier,Value2,5). 
	
we assign to the Modifier value of Atom Value2 because 5>0.
So hclasp selects the Value for which the Priority is higher.

This way we can write, for example:
	
	_heuristic(apply(A,T),true,2,10) :- poss(A,T).
	_heuristic(apply(A,T),true,1,0)  :- action(A).
	
so that we always branch on true actions due to the second rule, 
but among those we prefer to branch on the actions that are possible (by rule 1).

When for the same Atom, Modifier and Priority there are many heuristic atoms 
assigning different values, then hclasp assigns to the Modifier of the Atom 
the result of adding:
	- the highest possible value, and
	- the smallest negative value

For example, if we had:	
	_heuristic(apply(A,T),level,4, 0) :- action(A),a.
	_heuristic(apply(A,T),level,2, 0) :- action(A),b.
	_heuristic(apply(A,T),level,-1,0) :- action(A),c.
	_heuristic(apply(A,T),level,-5,0) :- action(A),d.
hclasp would assign to the level of apply(a,3):
	-1 if a,b,c and d hold
	3  if a, b and c hold

Internally, hclasp handles 
		_heuristic(Atom,Modifier,Value,Priority).
atoms as explained, where Modifier can be: init,factor,level,sign.
And implicitly defines:
	_heuristic(Atom,Modifier,Value,#abs(Value)) :- _heuristic(Atom,Modifier,Value).
and:
	_heuristic(Atom,sign,1)      :- _heuristic(Atom,true,Value).
	_heuristic(Atom,level,Value) :- _heuristic(Atom,true,Value).
and	
	_heuristic(Atom,sign,-1)     :- _heuristic(Atom,false,Value).
	_heuristic(Atom,level,Value) :- _heuristic(Atom,false,Value).
so that we can use _heuristic/3 predicates, and true and false as modifiers.	



===========================================================
		HCLASP subset minimization
===========================================================


To compute one answer set that is minimal wrt a set of atoms a/1, 
add to hclasp the sentence:
	_heuristic(a(X),false,1) :- ground(X).
Example (Reiter-style diagnosis):
	_heuristic(ab(X),false,1) :- component(X).

To minimize first the atoms a/1 and then with less priority the atoms b/1, 
add to hclasp:
	_heuristic(a(X),false,2) :- ground(X).
	_heuristic(b(X),false,1) :- ground(X).

To minimize first the atoms a/1, then with less priority the atoms b/1, 
fixing (as in circumscription) atoms c/1, add to hclasp:
	_heuristic(a(X),false,2) :- ground(X).
	_heuristic(b(X),false,1) :- ground(X).
	_heuristic(c(X),level,2) :- ground(X).

For maximizing sets of atoms just use "true" instead of "false" inside the _heuristic atom.
Example (diagnosis upside down): 
	_heuristic(correct(X),true,1) :- component(X).


Enumeration
-----------

To compute all answer sets that are subset optimal wrt a set of atoms a/1, 
add to hclasp the corresponding sentence and use options "--heu=domain -e record n", 
where n is the number of solutions you want to compute (use 0 to compute all minimal solutions).
Right now hclasp enumerates solutions projected on the set of atoms to optimize:
that is, if there are two optimal models that interpret the same way the atoms to minimize, 
only one of them is given.

Definition:
L+ is the set of atoms that, after grounding, have a level>0 and sign>0 assigned by hclasp,
L- is the set of atoms that, after grounding, have a level>0 and sign<0 assigned by hclasp, and
L? is the set of atoms that, after grounding, have a level>0 and sign=0 assigned by hclasp.
On enumeration with option "-e record" hclasp returns all answer sets that subset-optimal wrt the set of literals:
	L+ U {-l | l \in L-} U L? U {-l | l \in L?}
projecting on the set of atoms L+ U L- U L?
The first answer set returned is optimal wrt that set, but also wrt the level ranking.

So for enumeration hclasp does not handle different levels.
The first answer set is optimal wrt different levels, 
but for the rest hclasp considers that 
for all atoms that have a level, they have the same level.
Example e.lp:
	1{a,b}. _heuristic(a,false,1). _heuristic(b,false,2).
Execution:
	gringo e.lp | hclasp --heu=domain -e record 0
Answer Set 1:
	a.
Answer Set 2:
	b.
Only the first answer set is minimal wrt the order {-b}<{-a}, 
but hclasp only respects this order for the first answer set, 
while for the rest it simply maximizes the set {-b,-a}.

Important!
Note that varying the levels dynamically may affect hclasp results, 
so for subset minimization dynamic rules for level should be used with care.   


Enumeration with _true atom
---------------------------

hclasp with option "--heu domain -e record n"
will stop enumerating answer sets as soon as one of them contains the atom:
	_true

