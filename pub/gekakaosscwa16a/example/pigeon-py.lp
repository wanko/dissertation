#script (python)

class Pigeonator: #( \label{prg:pigeon:prop:begin-proptor}  #)
    def __init__(self): #( \label{prg:pigeon:prop:begin-cons} #)
        self.place = {} # shared state #( \label{prg:pigeon:prop:member-place} #)
        self.state = [] # per thread state #( \label{prg:pigeon:prop:member-state} \label{prg:pigeon:prop:end-cons} #)

    def init(self, init): #( \label{prg:pigeon:prop:begin-init} #)
        for atom in init.symbolic_atoms.by_signature("place", 2): #( \label{prg:pigeon:prop:init:loop-atoms} #)
            lit = init.solver_literal(atom.literal) #( \label{prg:pigeon:prop:init:map-literal} #)
            # store hole H of each place(P,H) atom
            self.place[lit] = atom.symbol.args[1] #( \label{prg:pigeon:prop:init:map-lit-hole} #)
            init.add_watch(lit) #( \label{prg:pigeon:prop:init:end-loop-atoms} #)
        self.state = [ {} for _ in range(init.num_threads) ] #( \label{prg:pigeon:prop:end-init} \label{prg:pigeon:prop:init:state} #)

    def propagate(self, control, changes):#( \label{prg:pigeon:prop:begin-prop} #)
        holes = self.state[control.thread_id] #( \label{prg:pigeon:prop:prop:state} #)
        for lit in changes: #( \label{prg:pigeon:prop:prop:begin-loop} #)
            hole = self.place[lit] #( \label{prg:pigeon:prop:prop:pigeon-to-hole} #)
            prev = holes.setdefault(hole, lit) #( \label{prg:pigeon:prop:prop:setdefault} #)
            if prev != lit and not control.add_nogood([lit, prev]): #( \label{prg:pigeon:prop:prop:add-clause} #)
                return #( \label{prg:pigeon:prop:end-prop} \label{prg:pigeon:prop:prop:end-loop} #)

    def undo(self, thread_id, assignment, changes): #( \label{prg:pigeon:prop:begin-undo} #)
        holes = self.state[thread_id] #( \label{prg:pigeon:prop:undo:state} #)
        for lit in changes: #( \label{prg:pigeon:prop:undo:begin-loop} #)
            hole = self.place[lit] #( \label{prg:pigeon:prop:undo:pigeon-to-hole} #)
            if holes.get(hole) == lit: #( \label{prg:pigeon:prop:undo:test} #)
                del holes[hole] #( \label{prg:pigeon:prop:end-proptor} \label{prg:pigeon:prop:end-undo} \label{prg:pigeon:prop:undo:del} #)

def main(prg): #( \label{prg:pigeon:prop:begin-main} #)
    prg.register_propagator(Pigeonator()) #( \label{prg:pigeon:prop:register} #)
    prg.ground([("base", [])])
    prg.solve() #( \label{prg:pigeon:prop:solve} \label{prg:pigeon:prop:end-main} #)

#end.

1 { place(P,H) : H = 1..$h$ } 1 :- P = 1..$p$. #( \label{prg:pigeon:prop:rule1} #)
% { place(P,H) : P = 1..$\color{darkgray}p$ } 1 :- H = 1..$\color{darkgray}h$. #( \label{prg:pigeon:prop:rule2} #)
