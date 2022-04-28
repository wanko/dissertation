#script (python)

# Priority dictionary using binary heaps
# David Eppstein, UC Irvine, 8 Mar 2002

from __future__ import generators

class priorityDictionary(dict):
    def __init__(self):
        '''Initialize priorityDictionary by creating binary heap
of pairs (value,key).  Note that changing or removing a dict entry will
not remove the old pair from the heap until it is found by smallest() or
until the heap is rebuilt.'''
        self.__heap = []
        dict.__init__(self)

    def smallest(self):
        '''Find smallest item after removing deleted items from heap.'''
        if len(self) == 0:
            raise IndexError, "smallest of empty priorityDictionary"
        heap = self.__heap
        while heap[0][1] not in self or self[heap[0][1]] != heap[0][0]:
            lastItem = heap.pop()
            insertionPoint = 0
            while 1:
                smallChild = 2*insertionPoint+1
                if smallChild+1 < len(heap) and \
                        heap[smallChild] > heap[smallChild+1]:
                    smallChild += 1
                if smallChild >= len(heap) or lastItem <= heap[smallChild]:
                    heap[insertionPoint] = lastItem
                    break
                heap[insertionPoint] = heap[smallChild]
                insertionPoint = smallChild
        return heap[0][1]
    
    def __iter__(self):
        '''Create destructive sorted iterator of priorityDictionary.'''
        def iterfn():
            while len(self) > 0:
                x = self.smallest()
                yield x
                del self[x]
        return iterfn()
    
    def __setitem__(self,key,val):
        '''Change value stored in dictionary and add corresponding
pair to heap.  Rebuilds the heap if the number of deleted items grows
too large, to avoid memory leakage.'''
        dict.__setitem__(self,key,val)
        heap = self.__heap
        if len(heap) > 2 * len(self):
            self.__heap = [(v,k) for k,v in self.iteritems()]
            self.__heap.sort()  # builtin sort likely faster than O(n) heapify
        else:
            newPair = (val,key)
            insertionPoint = len(heap)
            heap.append(None)
            while insertionPoint > 0 and \
                    newPair < heap[(insertionPoint-1)//2]:
                heap[insertionPoint] = heap[(insertionPoint-1)//2]
                insertionPoint = (insertionPoint-1)//2
            heap[insertionPoint] = newPair
    
    def setdefault(self,key,val):
        '''Reimplement setdefault to call our customized __setitem__.'''
        if key not in self:
            self[key] = val
        return self[key]


class dl_graph:
    def __init__(self):
        self.__graph=None
        self.__pos_graph=None
        self.__potential_function=None
        self.__valid=False
        self.__symbol_table={}
        self.__predecessor={}
    
    def set_symbol_table(self,map):
        self.__symbol_table=map
        
    def get_symbol_table(self):
        return self.__symbol_table
        
        
    def is_valid(self):
        return self.__valid
        
    def set_edges(self, edges):
        self.__edges=edges
        
    def reset_potential(self):
        self.__potential_function=None
        self.__graph=None
        self.__predecessor=None
        self.__valid=False
        
    def get_potential_function(self):
        return self.__potential_function
        
    def get_predecessor(self,map_nodes=True):
        predecessor={}
        if self.__valid:
            for node in self.__predecessor:
                if node == -2:
                    continue
                pred=self.__predecessor[node]
                if pred==None or pred == -2:
                    if map_nodes and node in self.__symbol_table:
                        predecessor[self.__symbol_table[node]]=None
                    else:
                        predecessor[node]=None
                else:
                    if map_nodes and node in self.__symbol_table:
                        if pred in self.__symbol_table:
                            predecessor[self.__symbol_table[node]]=self.__symbol_table[pred]
                        else:
                            predecessor[self.__symbol_table[node]]=pred
                    else:
                        predecessor[node]=pred  
        return predecessor
        
    def get_assignment(self,map_nodes=False):
        assignment={}
        if self.__valid:
            for node in self.__potential_function:
                if map_nodes and node in self.__symbol_table:
                    assignment[self.__symbol_table[node]]=-self.__potential_function[node]
                else:
                    assignment[node]=-self.__potential_function[node]
                    
        return assignment
        
    def get_potential(self,node):
        if node in self.__potential_function:
            return self.__potential_function[node]
        return None
        
    def add_edges(self,state):
        if self.__graph!=None and self.__potential_function!=None:
            graph=dict(self.__graph)
            pf=dict(self.__potential_function)
        else:
            graph=None
            pf=None
        neg_cycle=None
        if self.__valid:
            eid = state.stack[-1][1]
        else:
            eid=0
            self.reset_potential()
    
        for lit in state.edge_trail[eid:]:
            for edge in self.__edges[lit]:
                if self.__graph==None:
                    self.__graph={}
                self.__graph.setdefault(edge[0], {})
                self.__graph.setdefault(edge[1], {})
                if edge[0] in self.__graph and edge[1] in self.__graph[edge[0]] and self.__graph[edge[0]][edge[1]] <= edge[2]:
                    continue
                neg_cycle = self.add_edge(edge)
                if neg_cycle:
                    self.__graph=graph
                    self.__potential_function=pf
                    return neg_cycle
        return neg_cycle
        
    def add_edge(self,edge):
        u,v,d=edge
        if not self.__potential_function:
            self.__potential_function = {}
            self.__potential_function[u]=0
            self.__potential_function[v]=d
            self.__graph={u:{v:d},v:{}}
            self.__predecessor={u:None,v:u}
            self.__valid=True
            return None       
         
        neg_cycle=None 
        new_pf=dict(self.__potential_function)
        
        if u not in new_pf:
            new_pf[u]=0    
            self.__predecessor[u]=None
        if v not in new_pf:
            new_pf[v]=new_pf[u]+d
            self.__predecessor[v]=u
        
        gamma={}
        last_edges={}
            
        gamma[v]=new_pf[u]+d-new_pf[v]
        for node in new_pf:
            if node!=v:
                gamma[node]=0
                
            
        s, min_gamma = v,gamma[v]
        if min_gamma < 0:
            last_edges[v]=(u,v,d)
            if self.__predecessor[v] == None:
                self.__predecessor[v]=u
            elif new_pf[self.__predecessor[v]]+self.__graph[self.__predecessor[v]][v] > new_pf[u]+gamma[u]+d:
                self.__predecessor[v]=u

        while min_gamma<0:
            if gamma[u]<0:
                neg_cycle=True
                break
            new_pf[s]+=gamma[s]
            gamma[s]=0
            for t in self.__graph[s]:
                if self.get_potential(t)==new_pf[t]:
                    gamma[t]=min(gamma[t],new_pf[s]+self.__graph[s][t]-new_pf[t])
                    if gamma[t] < 0:
                        last_edges[t]=(s,t,self.__graph[s][t])
                        if self.__predecessor[t] == None:
                            self.__predecessor[t]=s
                        elif new_pf[self.__predecessor[t]]+self.__graph[self.__predecessor[t]][t] > new_pf[s]+gamma[s]+self.__graph[s][t]:
                            self.__predecessor[t]=s
            s = min(gamma, key=gamma.get)
            min_gamma = gamma[s]
            
        if neg_cycle:
            neg_cycle=[]
            begin=v
            x,y,c=last_edges[begin]
            neg_cycle.append((x,y,c))
            next=x
            while begin != next:
                x,y,c=last_edges[next]
                neg_cycle.append((x,y,c))
                next=x
            self.__valid=False
        else:
            self.__potential_function=new_pf
            self.__graph.setdefault(u,{})[v]=d
            self.__graph.setdefault(v,{})
            self.__valid=True

        return neg_cycle
                
        
    # Step 1: For each node prepare the destination and predecessor
    def __initialize(self, graph, source):
        d = {} # Stands for destination
        p = {} # Stands for predecessor
        for node in graph:
            d[node] = float('Inf') # We start admiting that the rest of nodes are very very far
            p[node] = None
        d[source] = 0 # For the source we know how to reach
        return d, p

    def __relax(self, node, neighbour, graph, d, p, last_edges):
        # If the distance between the node and the neighbour is lower than the one I have now
        if d[neighbour] > d[node] + graph[node][neighbour]:
            # Record this lower distance
            d[neighbour] = d[node] + graph[node][neighbour]
            p[neighbour] = node
            last_edges[neighbour]=(node,neighbour,graph[node][neighbour])
            
    def bellman_ford(self,source):
        return self.__bellman_ford(self.__graph, source)

    def __bellman_ford(self,graph, source):
        d, p = self.__initialize(graph, source)
        last_edges={}
        for i in range(len(graph)-1): #Run this until is converges
            for u in graph:
                for v in graph[u]: #For each neighbour of u
                    self.__relax(u, v, graph, d, p, last_edges) #Lets relax it

        # Step 3: check for negative-weight cycles
        neg_cycle = False
        for u in graph:
            for v in graph[u]:
                neg_cycle = d[v] > d[u] + graph[u][v]
                if neg_cycle:
                    last_edges[v]=(u,v,graph[u][v])
                    neg_cycle=[]
                    begin=u
                    reached=[begin]
                    x,y,c=last_edges[begin]
                    neg_cycle.append((x,y,c))
                    next=x
                    while next not in reached:
                        x,y,c=last_edges[next]
                        reached.append(y)
                        neg_cycle.append((x,y,c))
                        next=x
                    self.__valid=False
                    return neg_cycle, d, p 
        self.__potential_function=d
        self.__predecessor=p
        self.__valid=True
        
        return neg_cycle, d, p
    def __make_positive(self,G):
        G_pos={}
        for u in G:
            G_pos.setdefault(u,{})
            for v in G[u]:
                G_pos.setdefault(v,{})
                if G[u][v]>=0:
                    G_pos[u][v]=G[u][v]
                else:
                    G_pos[u][v]=self.__potential_function[u]+G[u][v]-self.__potential_function[v]
                    
        return G_pos
                    
    def __reverse(self,G):
        G_reverse={}
        for u in G:
            G_reverse.setdefault(u,{})
            for v in G[u]:
                G_reverse.setdefault(v,{})[u]=G[u][v]
        
        return G_reverse
        
    def dijkstra(self,source,end=None,reverse=False, graph=None):
        if graph != None:
            if reverse:
                G=self.__reverse(self.__make_positive(graph))  
            else:
                G=self.__make_positive(graph)  
            return self.__dijkstra(G, source,end=end)  
        elif self.__valid:
            if reverse:
                G=self.__reverse(self.__make_positive(self.__graph))  
            else:
                G=self.__make_positive(self.__graph)  
            return self.__dijkstra(G, source,end=end)
        else:
            return None
        
    # Dijkstra's algorithm for shortest paths
    # David Eppstein, UC Irvine, 4 April 2002

    def __dijkstra(self,G,start,end=None):
        """
        Find shortest paths from the start vertex to all
        vertices nearer than or equal to the end.
    
        The input graph G is assumed to have the following
        representation: A vertex can be any object that can
        be used as an index into a dictionary.  G is a
        dictionary, indexed by vertices.  For any vertex v,
        G[v] is itself a dictionary, indexed by the neighbors
        of v.  For any edge v->w, G[v][w] is the length of
        the edge.  This is related to the representation in
        <http://www.python.org/doc/essays/graphs.html>
        where Guido van Rossum suggests representing graphs
        as dictionaries mapping vertices to lists of neighbors,
        however dictionaries of edges have many advantages
        over lists: they can store extra information (here,
        the lengths), they support fast existence tests,
        and they allow easy modification of the graph by edge
        insertion and removal.  Such modifications are not
        needed here but are important in other graph algorithms.
        Since dictionaries obey iterator protocol, a graph
        represented as described here could be handed without
        modification to an algorithm using Guido's representation.
    
        Of course, G and G[v] need not be Python dict objects;
        they can be any other object that obeys dict protocol,
        for instance a wrapper in which vertices are URLs
        and a call to G[v] loads the web page and finds its links.
        
        The output is a pair (D,P) where D[v] is the distance
        from start to v and P[v] is the predecessor of v along
        the shortest path from s to v.
        
        Dijkstra's algorithm is only guaranteed to work correctly
        when all edge lengths are positive. This code does not
        verify this property for all edges (only the edges seen
        before the end vertex is reached), but will correctly
        compute shortest paths even for some graphs with negative
        edges, and will raise an exception if it discovers that
        a negative edge has caused it to make a mistake.
        """
    
        D = {}  # dictionary of final distances
        P = {}  # dictionary of predecessors
        Q = priorityDictionary()   # est.dist. of non-final vert.
        Q[start] = 0
                
        for v in Q:
            D[v] = Q[v]
            if v == end: break
            
            for w in G[v]:
                vwLength = D[v] + G[v][w]
                if w in D:
                    if vwLength < D[w]:
                        raise ValueError, \
      "Dijkstra: found better path to already-final vertex"
                elif w not in Q or vwLength < Q[w]:
                    Q[w] = vwLength
                    P[w] = v
        
        return (D,P)
                
    def shortestPath(self,G,start,end):
        """
        Find a single shortest path from the given start vertex
        to the given end vertex.
        The input has the same conventions as Dijkstra().
        The output is a list of the vertices in order along
        the shortest path.
        """
    
        D,P = self.__dijkstra(G,start,end)
        Path = []
        while 1:
            Path.append(end)
            if end == start: break
            end = P[end]
        Path.reverse()
        return Path

        
    def getGraph(self):
        return self.__graph
        
    def get_pos_graph(self):
        return self.__pos_graph
        
     
   
    def get_graph(self,map=False):
        if map:
            graph = {}
            for u in self.__graph:
                if u != -2:
                    for v in self.__graph[u]:
                        graph.setdefault(self.__symbol_table[u],{})[self.__symbol_table[v]]=self.__graph[u][v]
            return graph
        else:
            return self.__graph


    def build_graph(self,state):
        graph={-1:{}} #constant 0 vertex
        pos_graph={}
        
      
        #build graph from edges --> graph = {v1:{v2:w}} for (v1,w,v2) in E
        for eid in state.edge_trail: 
            edges = self.__edges[eid]
            for edge in edges:
                graph.setdefault(edge[0],{})
                graph.setdefault(edge[1],{})
                if edge[1] in graph[edge[0]]:
                    if edge[2] < graph[edge[0]][edge[1]]:
                        graph[edge[0]][edge[1]]=edge[2]
                else:
                    graph[edge[0]][edge[1]]=edge[2]
        nodes = graph.keys()
        
        #build possible graph extensions
        for eid in self.__edges:
            if eid not in state.edge_trail:
                edges=self.__edges[eid]
                for edge in edges:
                    pos_graph.setdefault(edge[0], {}).setdefault(edge[1], []).append(edge[2])
        self.__pos_graph=pos_graph
        
        #add edge with weight 0 from vertex -2 to all vertices to make graph singlesource
        graph[-2]= {}
        for node in nodes:   
            graph[-2][node]= 0
        
        self.__graph=graph
    
    def return_graph(self,edges,possible=False):
        graph={} 
        
        if not possible:
            #build graph from edges --> graph = {v1:{v2:w}} for (v1,w,v2) in E
            for eid in edges: 
                edges = self.__edges[eid]
                for edge in edges:
                    graph.setdefault(edge[0],{})
                    graph.setdefault(edge[1],{})
                    if edge[1] in graph[edge[0]]:
                        if edge[2] < graph[edge[0]][edge[1]]:
                            graph[edge[0]][edge[1]]=edge[2]
                    else:
                        graph[edge[0]][edge[1]]=edge[2]
        else:            
            #build possible graph extensions
            for eid in self.__edges:
                if eid not in edges:
                    edges=self.__edges[eid]
                    for edge in edges:
                        graph.setdefault(edge[1], {})
                        graph.setdefault(edge[0], {}).setdefault(edge[1], []).append(edge[2])

        
        return graph

class differenceLogic:
    class State:
        def __init__(self):
            self.stack = []             # [(decision level, edge trail index)]
            self.edge_trail = []        # [edge literal]
            
    def __state(self, sid):
        while len(self.__states) <= sid:
            self.__states.append(differenceLogic.State())
        return self.__states[sid]
    
    def __init__(self, dl_graph, state_based, propagate, negation, trace):                 
        self.__edges = {}               # {literal:[(var1,var2,weight)]}
        self.__edges_to_lit = {}        # {(var1,var2,c):literal}
        self.__vert_map = {}            # {id:vertex}
        self.__vert_map_inv = {}        # {vertex:id}
        self.__states = []              # [state]
        self.__trace = trace
        self.__state_based = state_based
        self.__propagate = propagate
        self.__negation = negation
        self.__dl_graph=dl_graph
        self.__model_found=True
        self.__backtrack=False
        self.__show=False
        
    def map(self,node):
        return self.__vert_map[node]
    
    def give_id(self,name,id,map,inverse):
        if name not in map.values():
            map[id]=name
            inverse[name]=id
            new_id=id
            max_id=id+1
        else:
            max_id=id
            new_id=inverse[name]
            
        return new_id,max_id
        
    
    def init(self, init):
        vert_id=1
        self.__vert_map[-1]="0"
        self.__vert_map_inv["0"]=-1
        for atom in init.theory_atoms:
            term = atom.term
            # theory atom is a difference logic term
            if term.name == "diff":
                lit = init.solver_literal(atom.literal)
                if atom.guard[1].args!=[]: #check if constant is negative
                    weight=-atom.guard[1].args[0].number
                else:
                    weight=atom.guard[1].number
                
                u=str(atom.elements[0].terms[0].args[0])
                v=str(atom.elements[0].terms[0].args[1])

                u,vert_id=self.give_id(u,vert_id,self.__vert_map,self.__vert_map_inv)
                v,vert_id=self.give_id(v,vert_id,self.__vert_map,self.__vert_map_inv)
                    
                edge=(u,v,weight)
                self.__edges.setdefault(lit, []).append(edge)
                self.__edges_to_lit[edge]=lit
                init.add_watch(lit)
                
                if self.__negation:
                    edge=(v,u,-weight-1)
                    self.__edges.setdefault(-lit, []).append(edge)
                    self.__edges_to_lit[edge]=-lit
                    init.add_watch(-lit)
                    
                
            elif term.name == "show_assignment":
                self.__show=True
                
        self.__dl_graph.set_edges(self.__edges)
        self.__dl_graph.set_symbol_table(self.__vert_map)

    def propagate(self, control, assign, changes):
        state = self.__state(control.id)
        if len(state.stack) == 0 or state.stack[-1][0] < assign.decision_level:
            state.stack.append((assign.decision_level, len(state.edge_trail)))
         
        if self.__trace:
            print "Difference logic propagation", " ".join([str(map(lambda x: (self.__vert_map[x[0]],self.__vert_map[x[1]],x[2]), self.__edges[l])) for l in changes if l in self.__edges])
        edges_changed=False       
        for lit in changes:
            # edge literal is assigned true
            if assign.is_true(lit) and lit in self.__edges:
                edges_changed = True
                state.edge_trail.append(lit)
                edges=self.__edges[lit]
        
        if self.__state_based:
            if self.__model_found:
                self.__model_found=False
                self.__dl_graph.reset_potential()
            neg_cycle=self.__dl_graph.add_edges(state)
            if neg_cycle:
                self.__backtrack=True
        else:
            self.__dl_graph.build_graph(state)
            (neg_cycle,d,p) = self.__dl_graph.bellman_ford(-2)  #check for negative cycles             
        if neg_cycle:
            if self.__trace:
                print 'Negative cycle found, excluding edges:'
                print ':-'+','.join(map(lambda x:str((self.__vert_map[x[0]],self.__vert_map[x[1]],x[2])),neg_cycle))+'.'
            clause=map(lambda x : -self.__edges_to_lit[x], neg_cycle)
            if not (control.add_clause(clause) and control.propagate()): # conjunction of edges may not be true if there is a negative cycle  
                return False   
                
        if self.__propagate:
            if not self.__forward_propagate(control,state):
                return False
                
        return True
        
    def __forward_propagate(self,control,state):
        eid = state.stack[-1][1]
        edges_lists=map(lambda x:self.__edges[x],state.edge_trail[eid:])
        edge_lits=state.edge_trail[:eid]
        reason=edge_lits
        H=self.__dl_graph.return_graph(edge_lits,True)
        G=self.__dl_graph.return_graph(edge_lits)
                
        for edges in edges_lists:
            for edge in edges:
                shortest_to={}
                shortest_from={}
                x,y,c =edge
                reason.append(self.__edges_to_lit[(x,y,c)])
                G.setdefault(x,{})[y]=c
                H[x][y].remove(c)
                if x not in shortest_to:
                    (dx,px)=self.__dl_graph.dijkstra(x,graph=G,reverse=True)  
                    shortest_to[x]=dx
                else:
                    dx=shortest_to[x]  
                if y not in shortest_from:
                    (dy,py)=self.__dl_graph.dijkstra(y,graph=G)  
                    shortest_from[y]=dy
                else:
                    dy=shortest_from[y]  
                for u in H:
                    for v in H[u]:
                        for d in H[u][v]:
                            if u in dx and v in dy and v not in G[u]:
                                if dx[u] + c + dy[v] <= d:
                                    consequence=self.__edges_to_lit[(u,v,d)]
                                    if self.__trace:
                                        print_res=map(lambda x:self.__edges[x],reason)
                                        print_edges=[]
                                        for edges in print_res:
                                            for edge in edges:
                                                print_edges.append(str((self.__vert_map[edge[0]],self.__vert_map[edge[1]],edge[2])))
                                        print 'Propagate consequence:'
                                        print (self.__vert_map[u],self.__vert_map[v],d),':-'+','.join(print_edges)+'.'
                                    clause=map(lambda x : -x, reason)
                                    clause.append(consequence)
                                    if not (control.add_clause(clause) and control.propagate()):  
                                        return False  
                
        return True

    def undo(self, solver_id, undo):
        state = self.__state(solver_id)
        eid = state.stack[-1][1]
        del state.edge_trail[eid:]
        state.stack.pop()
        if self.__state_based and self.__backtrack:
            self.__backtrack=False
        else:    
            self.__dl_graph.reset_potential()

    def check(self, control, assign):
        state = self.__state(control.id)
        if not self.__dl_graph.is_valid():
            if self.__state_based:
                if self.__model_found:
                    self.__model_found=False
                    self.__dl_graph.reset_potential()
                neg_cycle=self.__dl_graph.add_edges(state)
            else:
                self.__dl_graph.build_graph(state)
                (neg_cycle,d,p) = self.__dl_graph.bellman_ford(-2)  #check for negative cycles     
            if neg_cycle:
                if self.__trace:
                    print 'Negative cycle found, excluding edges:'
                    print ':-'+','.join(map(lambda x:str((self.__vert_map[x[0]],self.__vert_map[x[1]],x[2])),neg_cycle))+'.'
                clause=map(lambda x : -self.__edges_to_lit[x], neg_cycle)
                if not (control.add_clause(clause) and control.propagate()): # conjunction of edges may not be true if there is a negative cycle  
                    return False  
                
        if self.__state_based:
            self.__model_found=True
        if self.__trace or self.__show:
            print 'Valid assignment for constraints found:'
            print " ".join([self.__vert_map[node]+"="+str(-self.__dl_graph.get_potential(node)) for node in self.__dl_graph.get_potential_function() if node >= 0])
        return True
        
class latencyOptimizer:
    class State:
        def __init__(self):
            self.stack = []             # [(decision level, edge trail index, time trail index)]
            self.edge_trail = []        # [edge literal]
            self.time_trail = []        # [time literal]
            self.assignment = None      # {variable:assignment}
            self.predecessor =None      # {variable:predecessor}
            self.current_exec = {}
            
    def __state(self, sid):
        while len(self.__states) <= sid:
            self.__states.append(latencyOptimizer.State())
        return self.__states[sid]
    
    def __init__(self, dl_graph, trace, bound):                 
        self.__edges = {}               # {literal:[(var1,var2,weight)]}
        self.__task_map = {}            # {id:task}
        self.__task_map_inv = {}        # {task:id}
        self.__dl_graph=dl_graph
        self.__edges_to_lit = {}        # {(var1,var2,c):literal}
        self.__states = []              # [state]
        self.__trace = trace
        self.__times = {}               # {lit:(time,task)}
        self.__times_to_lit = {}        # {(time,task):lit}
        if bound >= 0:
            self.__optVal = bound    # current best bound
        else:
            self.__optVal = float("inf")    # current best bound
        self.__show=False
    
    def give_id(self,name,id,map,inverse):
        if name not in map.values():
            map[id]=name
            inverse[name]=id
            new_id=id
            max_id=id+1
        else:
            max_id=id
            new_id=inverse[name]
            
        return new_id,max_id
        
    
    def init(self, init):
        
        task_id=1
        self.__task_map[-1]="0"
        self.__task_map_inv["0"]=-1
        for atom in init.theory_atoms:
            term = atom.term
              
            # theory atom is a difference logic term
            if term.name == "diff":
                lit = init.solver_literal(atom.literal)
                if atom.guard[1].args!=[]: #check if constant is negative
                    weight=-atom.guard[1].args[0].number
                else:
                    weight=atom.guard[1].number
                
                u=str(atom.elements[0].terms[0].args[0])
                v=str(atom.elements[0].terms[0].args[1])
                
                u,task_id=self.give_id(u,task_id,self.__task_map,self.__task_map_inv)
                v,task_id=self.give_id(v,task_id,self.__task_map,self.__task_map_inv)
                    
                edge=(u,v,weight)
                self.__edges.setdefault(lit, []).append(edge)
                
                self.__edges_to_lit[edge]=lit
                init.add_watch(lit)
              
            # theory atom is the configuration
            if term.name == "durations":
                for elem in atom.elements:
                    conf_type = str(elem.terms[0])
                    if conf_type == "executionTime":
                        task, time = map(str,elem.terms[1:])
                        task, task_id = self.give_id(task,task_id,self.__task_map,self.__task_map_inv)
                        lit = init.solver_literal(elem.condition_literal)
                        self.__times.setdefault(lit,[]).append((task,int(time)))
                        self.__times_to_lit[(task,int(time))]=lit
                        init.add_watch(lit)
                        
            elif term.name == "show_latency":
                self.__show=True
                            
                            
    def propagate(self, control, assign, changes):
        state = self.__state(control.id)
        if len(state.stack) == 0 or state.stack[-1][0] < assign.decision_level:
            state.stack.append((assign.decision_level, len(state.edge_trail), len(state.time_trail)))
        
        if self.__trace:    
            edges=[str(map(lambda x: (self.__task_map[x[0]],self.__task_map[x[1]],x[2]), self.__edges[l])) for l in changes if l in self.__edges]
            times=[str(map(lambda x: (self.__task_map[x[0]],x[1]), self.__times[l])) for l in changes if l in self.__times]
            print_list=edges
            print_list.extend(times)
            if print_list != []:
                print "Latency optimizazion propagation", " ".join(print_list) 
            
        edges_changed=False       
        for lit in changes:
            # edge literal is assigned true
            if assign.is_true(lit) and lit in self.__edges:
                edges_changed = True
                state.edge_trail.append(lit)
                edges=self.__edges[lit]
            if assign.is_true(lit) and lit in self.__times:
                state.time_trail.append(lit)
                executions=self.__times[lit]
                for execution in executions:
                    state.current_exec[execution[0]]=execution[1]
         
        if self.__dl_graph.is_valid():
            assignment=self.__dl_graph.get_assignment(map_nodes=True)
            state.assignment={}
            for node in assignment:
                if node in self.__task_map_inv:
                    state.assignment[self.__task_map_inv[node]]=assignment[node]
            
            predecessor=self.__dl_graph.get_predecessor(map_nodes=True)
            state.predecessor={}
            for node in predecessor:
                if node in self.__task_map_inv:
                    if predecessor[node]==None:
                        state.predecessor[self.__task_map_inv[node]]=None
                    else:
                        state.predecessor[self.__task_map_inv[node]]=self.__task_map_inv[predecessor[node]]
            
            if not self.check_latency(state, control):
                if edges_changed:
                    self.__dl_graph.reset_potential()
                return False
                
        return True

    def get_latency(self, state):
        if state.current_exec == {}:
            return 0,0
        d=state.assignment
        latency=-float('inf')
        worst_node=-1
        for node in state.current_exec:
            if node >=0 and node in d:
                endtime=d[node]+state.current_exec[node]
                if endtime>latency:
                    latency=endtime
                    worst_node=node
        return latency, worst_node

    def relevant_lits(self,state,worst_node):
        time=state.current_exec[worst_node]
        assignment=self.__times_to_lit[(worst_node,time)]
        p=state.predecessor
        if time >= self.__optVal:
            return [], assignment
        
        if worst_node in p:
            pred=p[worst_node]
        else:
            pred==None
        if pred==None:
            return [],assignment
        
        graph=self.__dl_graph.get_graph(map=True)
        edges=[(pred,worst_node,graph[self.__task_map[pred]][self.__task_map[worst_node]])]
        exec_time=time+state.current_exec[pred]
        current=pred
        
        while exec_time < self.__optVal:
            if current in p:
                pred=p[current]
            else:
                pred==None
            if pred==None or pred==current:
                return map(lambda x:self.__edges_to_lit[x],edges),assignment
            
            edges.append((pred,current,graph[self.__task_map[pred]][self.__task_map[current]]))
            exec_time+=state.current_exec[pred]
            current=pred
        
        return map(lambda x:self.__edges_to_lit[x],edges),assignment

    def exclude_assignment(self,state, control,latency,worst_node):
        edges,assignment=self.relevant_lits(state,worst_node)
        clause=map(lambda x:-x,edges)
        clause.append(-assignment)
        if self.__trace:
            print 'Excluding dominated partial assignment:', latency
            print_edges=[]
            for lit in edges:
                print_edges.extend(self.__edges[lit])
            print_edges=map(lambda y : str((self.__task_map[y[0]],self.__task_map[y[1]],y[2])),print_edges)
            print_times=map(lambda x: str((self.__task_map[x[0]],x[1])),self.__times[assignment])
            print ':-'+','.join(print_edges)+','+','.join(print_times)+'.'
        if not (control.add_clause(clause) and control.propagate()):
            return False
        return True

    def check_latency(self, state, control, model=False):     
        latency, worst_node = self.get_latency(state)   
        if self.__optVal <= latency:
            if not self.exclude_assignment(state, control, latency, worst_node):
                return False
        elif model and self.__optVal > latency:
            self.__optVal=latency
            return True                             
        return True

    def undo(self, solver_id, undo):
        state = self.__state(solver_id)
        eid = state.stack[-1][1]
        del state.edge_trail[eid:]
        tid = state.stack[-1][2]
        for lit in state.time_trail[tid:]:
            for time in self.__times[lit]:
                task=time[0]
                if task in state.current_exec:
                    del state.current_exec[task]
        del state.time_trail[tid:]
        state.stack.pop()

    def check(self, control, assign):
        state = self.__state(control.id)
        if self.__dl_graph.is_valid():
            assignment=self.__dl_graph.get_assignment(map_nodes=True)
            state.assignment={}
            for node in assignment:
                if node in self.__task_map_inv:
                    state.assignment[self.__task_map_inv[node]]=assignment[node]
            
            predecessor=self.__dl_graph.get_predecessor(map_nodes=True)
            state.predecessor={}
            for node in predecessor:
                if node in self.__task_map_inv:
                    if predecessor[node]==None:
                        state.predecessor[self.__task_map_inv[node]]=None
                    else:
                        state.predecessor[self.__task_map_inv[node]]=self.__task_map_inv[predecessor[node]]
        d=state.assignment
        
        if not self.check_latency(state, control,True):
            return False                
        
        if self.__trace or self.__show:
            print "Found better latency:", self.__optVal
                          
        return True


from gringo import *

def get(const,prg,default):
    val=prg.get_const(const)
    if isinstance(val,Term) and isinstance(default,int):
        val=val.number
    return val if val!=None else default

def main(prg):                  
    graph=dl_graph()
    bound=get("bound",prg,-1)
    dl = differenceLogic(graph, bool(get("state",prg,0)),bool(get("propagate",prg,0)),bool(get("negation",prg,0)),bool(get("trace",prg,0)))  
    lo = latencyOptimizer(graph,bool(get("trace",prg,0)),bound)      
    prg.register_propagator(lo)         
    prg.register_propagator(dl)
    if bound >= 0:
        prg.conf.solve.models = 1
    else:
        prg.conf.solve.models = 0
    prg.ground([("base", [])])
    prg.solve()
    print "OPTIMUM FOUND"

#end.
