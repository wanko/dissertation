#theory difference {
  constant    { - : 0, unary};
  diff_term   { - : 0, binary, left};
  &diff/0 : diff_term, {<=}, constant, any
}.

#const n=2.      #const m=1000.
task(1..n).      duration(T,200*T) :- task(T).

&diff { end(T)-start(T) } <= D :- task(T), duration(T,D).
