#include <incmode>.
#include "lp.lp".
#show.

#program step(n).

pos(n).

&lp{ q(n) } > 0.
&lp{ q(X) } <= n :- pos(X), query(n).

&lp{ q(X)     } != q(n)     :- X=1..n-1.

&lp{ q(X)+X-1 } != q(n)+n-1 :- X=1..n-1.
&lp{ q(X)-X+1 } != q(n)-n+1 :- X=1..n-1.

&show{ q(n) }.

