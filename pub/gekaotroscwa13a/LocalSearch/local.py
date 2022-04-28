#script (python)
import gringo
import sys
import json
import time

#
# METHOD:
#  - Add ab/1 atoms to the base program.
#    They will be minimized by clingo adding cardinality constraints.
#  - Define in predicate _next_heuristic/3 the value of _heuristic/3
#    for the next solve() call. For example, if
#      _next_heuristic(a,true,1)
#    holds at step T, then
#      _heuristic(a,true,1)
#    will be true at step T+1.
#    This allows to modify the heuristic for the next solve() from the current solve().
#  - Define predicates _atom/1, _mod/1 and _value/1 for all atoms,
#    modifiers and values that may appear in _next_heuristic/3.
#  - #show the atoms that may appear in _next_heuristic/3.
#

heuristic = """
#external _do_heuristic(Atom,Mod,Value) : _atom(Atom), _mod(Mod), _value(Value).

_heuristic(Atom,Mod,Value) :- _do_heuristic(Atom,Mod,Value).

#show _heuristic/3.
"""


constraint = """
:- limit #sum { 1, T : _ab(T) }.
"""


def _on_model(m):
    global ab, h, prev_h
    ab     = 0
    prev_h = h
    h      = []
    for i in m.atoms(gringo.Model.ATOMS):
        if   i.name()=="_ab": ab += 1
        elif i.name()=="_next_heuristic": h.append(i.args())
    print "Answer: \n" + " ".join(str(i) for i in m.atoms(gringo.Model.SHOWN) if i.name()[0] != "_")


def main():

    global ab, h, prev_h
    args = sys.argv[1:]

    start = time.time()
    ctl = gringo.Control()
    ctl.conf.solver.heuristic = "Domain"
    ctl.conf.solver.forget_on_step = 2
    ctl.conf.stats = 2
    for i in args: ctl.load(i)
    ctl.add("base",[],heuristic)
    ctl.add("constraint",["limit"],constraint)
    ctl.ground([("base",[])])

    step, ab, h, prev_h = 0, 0, [], []
    while True:

        print "step=", step, "\tab = ", ab
        ret = ctl.solve(on_model=_on_model)

        if ret == gringo.SolveResult.UNSAT: break

        ctl.ground([("constraint",[ab])])

        for i in prev_h: ctl.assign_external(gringo.Fun("_do_heuristic",i),False)
        for i in h:      ctl.assign_external(gringo.Fun("_do_heuristic",i),True )

        step += 1

    print json.dumps(ctl.stats['accu'], sort_keys=True, indent=4, separators=(',', ': '))

if __name__ == '__main__': main()

