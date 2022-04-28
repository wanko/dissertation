#script (python)

from clingo import Function

def get(val, default):#(\label{fig:iclingo:python:const:begin}#)
    return val if val != None else default

def main(prg):
    imin   = get(prg.get_const("imin"), 1)#(\label{fig:iclingo:python:imin}#)
    imax   = prg.get_const("imax")
    istop  = get(prg.get_const("istop"), "SAT")#(\label{fig:iclingo:python:const:end}\label{fig:iclingo:python:istop}#)

    step, ret = 0, None#(\label{fig:iclingo:python:vars}#)
    while ((imax is None or step < imax) and#(\label{fig:iclingo:python:loop:begin}#)
           (step == 0   or step < imin or (
              (istop == "SAT"     and not ret.satisfiable) or
              (istop == "UNSAT"   and not ret.unsatisfiable) or
              (istop == "UNKNOWN" and not ret.unknown)))):
        parts = []
        parts.append(("check", [step]))
        if step > 0:
            prg.release_external(Function("query", [step-1]))
            parts.append(("step", [step]))
            prg.cleanup()#(\label{fig:iclingo:python:cleanup}#)
        else:
            parts.append(("base", []))
        prg.ground(parts)
        prg.assign_external(Function("query", [step]), True)#(\label{fig:iclingo:python:assign:query}#)
        ret, step = prg.solve(), step+1#(\label{fig:iclingo:python:loop:end}\label{fig:iclingo:python:solve}#)
#end.

#program check(t).%%#(\label{fig:iclingo:python:check}#)
#external query(t).%%#(\label{fig:iclingo:python:query}#)
