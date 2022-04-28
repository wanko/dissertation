#theory difference { %( \label{prg:diff:begin-theory} %)
  constant    { - : 0, unary }; %( \label{prg:diff:begin-def-term} %)
  diff_term   { - : 0, binary, left };
  linear_term { + : 2, unary; - : 2, unary; 
                * : 1, binary, left; %( \label{prg:diff:op-mul} %)
                + : 0, binary, left; - : 0, binary, left };
  domain_term { .. : 1, binary, left }; %( \label{prg:diff:op-dot} %)
  show_term   { / : 1, binary, left }; %( \label{prg:diff:end-def-term} %)
  &dom/0 : domain_term, {=}, linear_term, any; %( \label{lst:ex1-begin-def-atom} %)
  &sum/0 : linear_term, {<=,=,>=,<,>,!=}, linear_term, any;
  &diff/0 : diff_term, {<=}, constant, any;
  &show/0 : show_term, directive %( \label{lst:ex1-end-def-atom} %)
}. %( \label{prg:diff:end-theory} %)

#const n=2.  #const m=1000. %( \label{prg:diff:begin-program} %)
task(1..n).  duration(T,200*T) :- task(T). %( \label{prg:diff:rule-task} \label{prg:diff:rule-duration} %)
&dom  { 1..m } = start(T) :- task(T). %( \label{prg:diff:begin-use-theory} %)
&dom  { 1..m } = end(T)   :- task(T). 
&diff { end(T)-start(T) } <= D :- duration(T,D). %( \label{prg:diff:rule-diff} %)
&sum  { end(T) : task(T); -start(T) : task(T) } <= m.
&show { start/1; end/1 }. %( \label{prg:diff:end-use-theory} \label{prg:diff:end-program} %)
