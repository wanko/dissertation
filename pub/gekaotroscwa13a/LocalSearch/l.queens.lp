#const n=13.
row(1..n).
col(1..n).

{ queen(I,J) : col(I) , row(J) }.

% :- not n { queen(I,J) } n).
% :- queen(I,J), queen(I,JJ), J != JJ.
% :- queen(I,J), queen(II,J), I != II.
% :- queen(I,J), queen(II,JJ), (I,J) != (II,JJ), I-J == II-JJ.
% :- queen(I,J), queen(II,JJ), (I,J) != (II,JJ), I+J == II+JJ.

%ab(1,()) 
:- not n { queen(I,J) } n.
_ab((2,(I,J,I, JJ))) :- queen(I,J), queen(I,JJ), J != JJ.
_ab((3,(I,J,II,J ))) :- queen(I,J), queen(II,J), I != II.
_ab((4,(I,J,II,JJ))) :- queen(I,J), queen(II,JJ), (I,J) != (II,JJ), I-J == II-JJ.
_ab((5,(I,J,II,JJ))) :- queen(I,J), queen(II,JJ), (I,J) != (II,JJ), I+J == II+JJ.


%
% heuristic
%
_next_heuristic(queen(I ,J ),false,1) :- _ab((_,(I,J,II,JJ))).
_next_heuristic(queen(II,JJ),false,1) :- _ab((_,(I,J,II,JJ))).

_atom(queen(1..n,1..n)).
%_mod(sign). 
_mod(false).
%_mod(true).
_value(1).

#show queen/2.


