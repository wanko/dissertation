#script (python)

class DifferenceLogicGraph:
    def __init__(self):
        self.__graph={}               # {node : {node : weight}}
        self.__potential_function={}  # {node : potential}
        
    def empty(self):
        return len(self.__graph)==0
        
    def reset(self):
        self.__potential_function={}
        self.__graph={}
        
    def get_assignment(self):
        assignment={}
        # A valid assignment for each variable is the negated potential
        for node in self.__potential_function:
            assignment[node]=-self.__potential_function[node]
                    
        return assignment
    
    def __add_to_graph(self,u,v,d):
        # Make sure nodes are in the graph
        self.__graph.setdefault(u,{})
        self.__graph.setdefault(v,{})
        # If edge already exists from u to v with lower weight, new edge is redundant
        if not (v in self.__graph[u] and self.__graph[u][v] <= d):
            self.__graph[u][v]=d
        
    def add_edge(self,edge,map_nodes=False):
        u,v,d=edge
        #Initialize potential and graph
        self.__potential_function.setdefault(u,0)
        self.__potential_function.setdefault(v,0)    
        self.__graph.setdefault(u,{})
        self.__graph.setdefault(v,{})
         
        changed = set()   # Set of nodes for which potential has been changed
        gamma = {}        # {node : potential change}
        last_edges = {}   # {node : edge inducing potential change}
          
        # Update potential change induced by new edge, 0 for other nodes   
        gamma[v]=self.__potential_function[u]+d-self.__potential_function[v]
        for node in self.__potential_function:
            if node!=v:
                gamma[node]=0
                     
        s, min_gamma = v,gamma[v]
        if min_gamma < 0:
            last_edges[v]=(u,v,d)
        
        # Propagate negative potential change
        while min_gamma < 0 and gamma[u] == 0:
            if s not in changed:
                self.__potential_function[s]+=gamma[s]
                changed.add(s)
                for t in self.__graph[s]:
                    if t not in changed:
                        gamma_t=self.__potential_function[s]+self.__graph[s][t]-self.__potential_function[t]
                        if gamma_t < gamma[t]:
                            gamma[t] = gamma_t
                            last_edges[t]=(s,t,self.__graph[s][t])
            gamma[s]=0
            s = min(gamma, key=gamma.get)
            min_gamma = gamma[s]
            
        neg_cycle=None 
        
        # Check if negative cycle was found
        if gamma[u] < 0:
            # Retrace negative cycle
            neg_cycle=[]
            begin=v
            x,y,c=last_edges[begin]
            neg_cycle.append((x,y,c))
            next=x
            while begin != next:
                x,y,c=last_edges[next]
                neg_cycle.append((x,y,c))
                next=x
        else:
            self.__add_to_graph(u,v,d)
        return neg_cycle
 
class differenceLogic:
    class State:
        def __init__(self):
            self.propagated = 0         # trail index of checked literals
            self.edge_trail = []        # [edge literal]
            self.dl_graph = None        # Current graph object
            
    def __state(self, sid):
        # Initialize state objects if needed
        while len(self.__states) <= sid:
            state=differenceLogic.State()
            state.dl_graph=DifferenceLogicGraph()
            self.__states.append(state)
        # Return state of thread id sid
        return self.__states[sid]
    
    def __init__(self):                 
        self.__edges = {}               # {literal:[(var1,var2,weight)]}
        self.__edges_to_lit = {}        # {(var1,var2,weight):literal}
        self.__states = []              # [state]
        self.__multishot=False               # If true, one valid assignment is printed 
        self.__show=False               # If true, one valid assignment is printed 
        
    def set_multishot(self):
        self.__multishot = True
        
    def init(self, init):
        # Iterate through theory atoms in the program
        for atom in init.theory_atoms:
            term = atom.term
            # Theory atom is a difference logic term
            if term.name == "diff":
                lit = init.solver_literal(atom.literal) # Get solving literal of theory atom
                
                # Extract weight and variables from theory atom
                if atom.guard[1].arguments!=[]: #Check if constant is negative
                    weight=-atom.guard[1].arguments[0].number
                else:
                    weight=atom.guard[1].number
                
                u=str(atom.elements[0].terms[0].arguments[0])
                v=str(atom.elements[0].terms[0].arguments[1])
                
                # Save possible DL constraints as edges of constraint graph and map edges to solver literals
                edge=(u,v,weight)
                self.__edges.setdefault(lit, []).append(edge)
                self.__edges_to_lit[edge]=lit
                
                # Watch literals representing DL constraints
                init.add_watch(lit)
            
            # Theory atom is a show directive
            elif term.name == "show_assignment":
                self.__show=True
                
    
    def check_consistency(self,control,state):      
        # Check for negative cycle in the current state
        neg_cycle=None
    
        # Add edges represented by literals in trail and check for negative cycle
        eid = state.propagated
        if self.__multishot:
	    eid = 0
	    self.__multishot == False
        for lit in state.edge_trail[eid:]:
            for edge in self.__edges[lit]:
                neg_cycle = state.dl_graph.add_edge(edge)
                if neg_cycle:
                    clause=[]
                    # Add conflict clause
                    for edge in neg_cycle:
                        clause.append(-self.__edges_to_lit[edge])
                    # conjunction of edges may not be true if there is a negative cycle  
                    if not (control.add_clause(clause) and control.propagate()): 
                        return False   
            state.propagated+=1
        return True

    def propagate(self, control, changes):
        assign=control.assignment
        state = self.__state(control.thread_id)
            
        # Update state    
        for lit in changes:
            # edge literal is assigned true
            if assign.is_true(lit) and lit in self.__edges:
                state.edge_trail.append(lit)     
                
        # Check consistency of the state state
        if not self.check_consistency(control,state):
            return False   
          
        return True

    def undo(self, thread_id, assign, changes):
        # Delete literals from last decision level
        state = self.__state(thread_id)
        del state.edge_trail[len(state.edge_trail)-len(changes):]
        state.propagated = 0
        # Reset the graph
        state.dl_graph.reset()

    def check(self, control):
        state = self.__state(control.thread_id)
        if self.__multishot:
            self.check_consistency(control, state)
            self.__multishot = False
        # Print assignment
        if self.__show:
            assignment = state.dl_graph.get_assignment()
            print 'Valid assignment for constraints found:'
            print " ".join([node+"="+str(assignment[node]) for node in assignment if node != "0"])
        return True
        

import clingo
    
def get(val, default):
    return val if val != None else default
        
def main(prg):
    #Register propagator object
    dl = differenceLogic()  
    prg.register_propagator(dl)
    
    
    imin   = get(prg.get_const("imin"), clingo.Number(0))
    imax   = prg.get_const("imax")
    istop  = get(prg.get_const("istop"), clingo.String("SAT"))
    
    step, ret = 0, None
    while ((imax is None or step < imax.number) and
           (step == 0 or step < imin.number or (
              (istop.string == "SAT"     and not ret.satisfiable) or
              (istop.string == "UNSAT"   and not ret.unsatisfiable) or
              (istop.string == "UNKNOWN" and not ret.unknown)))):
        parts = []
        parts.append(("check", [step]))  
        if step > 0:
            prg.release_external(clingo.Function("query", [step-1]))
            prg.cleanup()
            parts.append(("step", [step]))
        else:
            parts.append(("base", []))
        prg.ground(parts)
        prg.assign_external(clingo.Function("query", [step]), True)
        ret, step = prg.solve(), step+1
        dl.set_multishot()
#end.   
        
#program check(t).
#external query(t). 

%Define theory language
#theory dl {
    term{};
    constant {- : 1, unary};
    diff_term {- : 1, binary, left};
    &diff/0 : diff_term, {<=}, constant, any;
    &show_assignment/0 : term, directive
}.
 
