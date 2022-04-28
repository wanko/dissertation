int(x;y).

a :- not b. b :- not a.
b :- not c. c :- not b.
c :- not d. d :- not c.
d :- not e. e :- not d.
e :- not f. f :- not e.

dl_ge(x,y,3) :- a.
dl_gt(x,y,3) :- b.
dl_le(x,y,3) :- c.
dl_lt(x,y,3) :- d.
dl_eq(x,y,3) :- e.
dl_ne(x,y,3) :- f.


