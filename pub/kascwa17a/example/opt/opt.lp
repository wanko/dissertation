#program bound(b).

:- #sum { V,I: _minimize(V,I) } >= b.%%#(\label{prg:opt:main:sum}#)

#script (python)

import clingo

def main(prg):
    prg.ground([("base", [])])#(\label{prg:opt:main:ground}#)
    while True: #( \label{prg:opt:loop:begin} #)
        bound = 0
        with prg.solve(yield_=True) as h:#(\label{prg:opt:main:solve}#)
            for m in h: #( \label{prg:opt:main:models:begin} #)
                for atom in m.symbols(atoms=True):#(\label{prg:opt:main:atoms:begin}#)
                    if (atom.name == "_minimize"
                    and len(atom.arguments) > 0
                    and atom.arguments[0].type
                    is  clingo.SymbolType.Number):#(\label{prg:opt:main:minimize:end}#)
                        bound += atom.arguments[0].number#(\label{prg:opt:main:atoms:end}#)
                break#(\label{prg:opt:main:models:end}#)
            else: #( \label{prg:opt:main:finish:begin} #)
                print "Optimum found"
                break#(\label{prg:opt:main:finish:end}#)
        print "Found new bound: {}".format(bound)#(\label{prg:opt:main:print_bound}#)
        prg.ground([("bound", [bound])])#(\label{prg:opt:main:ground_bound} \label{prg:opt:loop:end}#)

#end.
