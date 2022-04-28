
#################################################
    	ISCAS-85 circuits for ASP
#################################################


./gates.lp: description of the input-output relation of the gates

./diagnosis.lp: generate high and ab facts and display ab

./test_clasp.sh: script to execute all instances

/lp: representation of each of the iscas-85 circuits as sets of facts
	- input relation for the input gates
	- output relation for the output gates
	
/instances:
	for each circuit c in /lp
		for each instance i=1..50
			c.lp.i.in is an input to circuit c
			for each fault f=1..8
				c.lp.i.f.out is the output of the circuit c with f gate values changed 

Note: 
For each input there is a unique correct output, 
so we change f of the output gates in each *.f.out file				
				
Instances where generated randomly following the procedure of:
  Siddiqi, S. A. 2011. Computing minimum-cardinality diagnoses by model relaxation. IJCAI'11.
   
Example executing circuit c432 with 4 output gates changed on instance 1:
  gringo diagnosis.lp gates.lp lp/c432.lp instances/c432.lp.1.in instances/c432.lp.1.4.out | clasp
