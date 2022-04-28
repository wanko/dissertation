================================
  PDDL EXPERIMENTS WITH HCLASP
================================

 
 REFERENCES
============

Planning competitions websites:
	* 2000 http://www.cs.toronto.edu/aips2000/
	* 2002 http://planning.cis.strath.ac.uk/competition/

Planning conference website:
	http://icaps-conference.org/	
In Rintanen paper he uses this as reference, says:
	[28]	ICAPS. http://icaps-conference..org/,2010

Also, the website of the planning competition is the following:	
	http://ipc.icaps-conference.org/

I found no publication of the competitions.

	
 DOMAINS
=========

Domains:
	All STRIPS domains from 2000 and 2002 competitions
	except SCHEDULE from 2000 competition:
		because of grounding issues: grounding the simplest instance with gringo-3.0.4 
		it gives ERROR
			std::bad_alloc
		so we probably we wouldnt be able to ground any instance
		Rintanen also excluded it: 
			"We excluded the 2000 SCHEDULE domain from the comparison because of
			grounding issues, the overall simple structure of the domain, and the very high number 
			of instances (500)."

Domains and number of instances:
	2000-Blocks		38
	2000-Elevator	132
	2000-Freecell	62
	2000-Logistics	35
	2002-Depots		20
	2002-Driverlog	20
	2002-Freecell	20
	2002-Satellite	20
	2002-Zenotravel	20
	
For the 2000 competition domains, we chose only the 20 smallest instances of each.
For the 2002 competition domains, we chose the whole set of 20 instances.

For each instance, we tried lasttime values 5, 10, ... and 75. 

So we have: 10 domains * 20 instances/domain * 15 plan lengths = 3000 problems

	
 EXPERIMENTS
=============	

We used the plasp-2 translations of the instances, 
and we used as basic ASP encoding a direct translation of Rintanen encoding
(it is pasted at the end of this file).
	
We tested two systems:
	* clasp-2.1.0 with vsids 
	* hclasp-1.1 with file tetris.lp for the heuristic:

		% FILE: tetris.lp
		% branch on fluent literals backwards
		_heuristic(holds(F,T),true,lasttime-T+1) :- holds(F,T1), next(T,T1).
		_heuristic(holds(F,T),false,lasttime-T+1) :- not holds(F,T1), fluent(F), next(T,T1).
		#show holds/2.
		#show _heuristic/3.

		
I also tried tetris-pos.lp, and it went a bit worse than tetris.lp:

		% FILE: tetris-pos.lp
		% branch on fluent literals backwards
		_heuristic(holds(F,T),true,lasttime-T+1) :- holds(F,T1), next(T,T1).
		#show holds/2.
		#show _heuristic/3.

And also fwd.lp and bwd.lp that performed very badly:		

	% FILE: fwd.lp
	% branch on true actions forward
	_heuristic(apply(A,T),true,lasttime-T+1) :- action(A), time(T).
	#show apply/2.
	#show _heuristic/3.

	% FILE: bwd.lp
	% branch on true actions backward
	_heuristic(apply(A,T),true,T+1) :- action(A), time(T).
	#show apply/2.
	#show _heuristic/3.


 RESULTS
=========

Follow the table with the results:
	* each row corresponds to a domain (Rovers has to be corrected)
	* first clasp-vsids   time, models found and timeouts, 
	  then  hclasp-tetris time, models found and timeouts.
	* Then we consider only the instances for which either clasp-vsids or hclasp-tetris
	  found a model (ie., the instances that we know that are satisfiable).
	  First we give clasp-vsids time, models found and timeouts, and
	  then hclasp-tetris        time, models found and timeouts.

Domain,vsids-time,vsids-models,vsids-timeouts,tetris-time,tetris-models,tetris-timeouts,SAT-vsids-time,SAT-vsids-models,SAT-vsids-timeouts,SAT-tetris-time,SAT-tetris-models,SAT-tetris-timeouts
2000-Blocks,134.4,180,61,9.2,239,3,163.2,180,59,2.6,239,0
2000-Elevator,3.1,279,0,0.0,279,0,3.4,279,0,0.0,279,0
2000-Freecell,288.7,147,115,184.2,194,74,226.4,147,47,52,194,0
2000-Logistics,145.8,148,61,115.3,168,52,113.9,148,23,15.5,168,3
2002-Depots,400.3,51,184,297.4,115,135,389,51,64,61.6,115,0
2002-Driverlog,308.3,108,143,189.6,169,92,245.8,108,61,6.1,169,0
2002-Freecell,396.3,50,187,410.4,49,201,99.4,50,3,64,49,4
2002-Rovers
2002-Satellite,398.4,73,186,229.9,155,106,364.6,73,82,30.8,155,0
2002-Zenotravel,350.7,101,169,239,154,116,224.5,101,53,6.3,154,0
Total,242.9,1137,1106,167.9,1522,779,187,1137,392,20,1522,7


 ASP ENCODING
==============

#domain time(T).
#domain time(T1).
time(0..lasttime).
next(T,T1) :- T1 = T + 1.

% fluents for sat planning
fluent(F) :- init(F). fluent(F) :- adds(A,F).
{ holds(F,T) } :- fluent(F), T > 0.

% non concurrent actions
0 { apply(A,T) : action(A) } 1 :- T!=lasttime.

% initial situation
holds(F,0) :- init(F).

% actions preconditions
:- not holds(F,T), apply(A,T), demands(A,F,true).
:- holds(F,T), apply(A,T),    demands(A,F,false).

% actions direct effects
:- not holds(F,T1), apply(A,T), adds(A,F), next(T,T1).
:- holds(F,T1), apply(A,T), deletes(A,F),  next(T,T1).

% inertia
:- holds(F,T1), not holds(F,T), not apply(A,T) : adds(A,F),    next(T,T1).
:- not holds(F,T1), holds(F,T), not apply(A,T) : deletes(A,F), next(T,T1).

% final situation
:- not holds(F,lasttime), goal(F,true).
:- holds(F,lasttime),  goal(F,false).

% display
#hide.
#show apply/2.


