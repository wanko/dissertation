%%% neg ( = not )
:- not ab(O), not high(O), not high(I1), neg(I1,O).
:- not ab(O), high(O), high(I1), neg(I1,O).
gate(O) :- neg(I1,O).

%%% buff
:- not ab(O), not high(O), high(I1), buff(I1,O).
:- not ab(O), not high(I1), high(O), buff(I1,O).
gate(O) :- buff(I1,O).

%%% nand2
:- not ab(O), not high(O), not high(I1), nand2(I1,I2,O).
:- not ab(O), not high(O), not high(I2), nand2(I1,I2,O).
:- not ab(O), nand2(I1,I2,O), high(O), high(I1), high(I2).
gate(O) :- nand2(I1,I2,O).

%%% nand3
:- not ab(O), not high(O), not high(I1), nand3(I1,I2,I3,O).
:- not ab(O), not high(O), not high(I2), nand3(I1,I2,I3,O).
:- not ab(O), not high(O), not high(I3), nand3(I1,I2,I3,O).
:- not ab(O), nand3(I1,I2,I3,O), high(O), high(I1), high(I2), high(I3).
gate(O) :- nand3(I1,I2,I3,O).

%%% nand4
:- not ab(O), not high(O), not high(I1), nand4(I1,I2,I3,I4,O).
:- not ab(O), not high(O), not high(I2), nand4(I1,I2,I3,I4,O).
:- not ab(O), not high(O), not high(I3), nand4(I1,I2,I3,I4,O).
:- not ab(O), not high(O), not high(I4), nand4(I1,I2,I3,I4,O).
:- not ab(O), nand4(I1,I2,I3,I4,O), high(O), high(I1), high(I2), high(I3), high(I4).
gate(O) :- nand4(I1,I2,I3,I4,O).

%%% nand5
:- not ab(O), not high(O), not high(I1), nand5(I1,I2,I3,I4,I5,O).
:- not ab(O), not high(O), not high(I2), nand5(I1,I2,I3,I4,I5,O).
:- not ab(O), not high(O), not high(I3), nand5(I1,I2,I3,I4,I5,O).
:- not ab(O), not high(O), not high(I4), nand5(I1,I2,I3,I4,I5,O).
:- not ab(O), not high(O), not high(I5), nand5(I1,I2,I3,I4,I5,O).
:- not ab(O), nand5(I1,I2,I3,I4,I5,O), high(O), high(I1), high(I2), high(I3), high(I4), high(I5).
gate(O) :- nand5(I1,I2,I3,I4,I5,O).

%%% nand8
:- not ab(O), not high(O), not high(I1), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), not high(O), not high(I2), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), not high(O), not high(I3), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), not high(O), not high(I4), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), not high(O), not high(I5), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), not high(O), not high(I6), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), not high(O), not high(I7), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), not high(O), not high(I8), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), nand8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I1), high(I2), high(I3), high(I4), high(I5), high(I6), high(I7), high(I8).
gate(O) :- nand8(I1,I2,I3,I4,I5,I6,I7,I8,O).

%%% nor2
:- not ab(O), not high(O), not high(I1), not high(I2), nor2(I1,I2,O).
:- not ab(O), nor2(I1,I2,O), high(O), high(I1).
:- not ab(O), nor2(I1,I2,O), high(O), high(I2).
gate(O) :- nor2(I1,I2,O).

%%% nor3
:- not ab(O), not high(O), not high(I1), not high(I2), not high(I3), nor3(I1,I2,I3,O).
:- not ab(O), nor3(I1,I2,I3,O), high(O), high(I1).
:- not ab(O), nor3(I1,I2,I3,O), high(O), high(I2).
:- not ab(O), nor3(I1,I2,I3,O), high(O), high(I3).
gate(O) :- nor3(I1,I2,I3,O).

%%% nor4
:- not ab(O), not high(O), not high(I1), not high(I2), not high(I3), not high(I4), nor4(I1,I2,I3,I4,O).
:- not ab(O), nor4(I1,I2,I3,I4,O), high(O), high(I1).
:- not ab(O), nor4(I1,I2,I3,I4,O), high(O), high(I2).
:- not ab(O), nor4(I1,I2,I3,I4,O), high(O), high(I3).
:- not ab(O), nor4(I1,I2,I3,I4,O), high(O), high(I4).
gate(O) :- nor4(I1,I2,I3,I4,O).

%%% nor8
:- not ab(O), not high(O), not high(I1), not high(I2), not high(I3), not high(I4), not high(I5), not high(I6), not high(I7), not high(I8), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I1).
:- not ab(O), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I2).
:- not ab(O), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I3).
:- not ab(O), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I4).
:- not ab(O), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I5).
:- not ab(O), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I6).
:- not ab(O), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I7).
:- not ab(O), nor8(I1,I2,I3,I4,I5,I6,I7,I8,O), high(O), high(I8).
gate(O) :- nor8(I1,I2,I3,I4,I5,I6,I7,I8,O).

%%% xor2
:- not ab(O), not high(O), not high(I2), high(I1), xor2(I1,I2,O).
:- not ab(O), not high(O), not high(I1), high(I2), xor2(I1,I2,O).
:- not ab(O), not high(I1), not high(I2), high(O), xor2(I1,I2,O).
:- not ab(O), high(I1), high(I2), high(O), xor2(I1,I2,O).
gate(O) :- xor2(I1,I2,O).

%%% or2
:- not ab(O), not high(O), high(I1), or2(I1,I2,O). 				   
:- not ab(O), not high(O), high(I2), or2(I1,I2,O). 				   
:- not ab(O), not high(I1), not high(I2), high(O), or2(I1,I2,O).
gate(O) :- or2(I1,I2,O).

%%% or3
:- not ab(O), not high(O), high(I1), or3(I1,I2,I3,O). 				   
:- not ab(O), not high(O), high(I2), or3(I1,I2,I3,O). 				   
:- not ab(O), not high(O), high(I3), or3(I1,I2,I3,O). 				   
:- not ab(O), not high(I1), not high(I2), not high(I3), high(O), or3(I1,I2,I3,O).
gate(O) :- or3(I1,I2,I3,O).

%%% or4
:- not ab(O), not high(O), high(I1), or4(I1,I2,I3,I4,O). 				   
:- not ab(O), not high(O), high(I2), or4(I1,I2,I3,I4,O). 				   
:- not ab(O), not high(O), high(I3), or4(I1,I2,I3,I4,O). 				   
:- not ab(O), not high(O), high(I4), or4(I1,I2,I3,I4,O). 				   
:- not ab(O), not high(I1), not high(I2), not high(I3), not high(I4), high(O), or4(I1,I2,I3,I4,O).
gate(O) :- or4(I1,I2,I3,I4,O).

%%% or5
:- not ab(O), not high(O), high(I1), or5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(O), high(I2), or5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(O), high(I3), or5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(O), high(I4), or5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(O), high(I5), or5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(I1), not high(I2), not high(I3), not high(I4), not high(I5), high(O), or5(I1,I2,I3,I4,I5,O).
gate(O) :- or5(I1,I2,I3,I4,I5,O).

%%% and2
:- not ab(O), not high(O), high(I1), high(I2), and2(I1,I2,O).
:- not ab(O), not high(I1), high(O), and2(I1,I2,O). 				   
:- not ab(O), not high(I2), high(O), and2(I1,I2,O). 				   
gate(O) :- and2(I1,I2,O). 				   

%%% and3
:- not ab(O), not high(O), high(I1), high(I2), high(I3),
                   and3(I1,I2,I3,O).
:- not ab(O), not high(I1), high(O), and3(I1,I2,I3,O). 				   
:- not ab(O), not high(I2), high(O), and3(I1,I2,I3,O). 				   
:- not ab(O), not high(I3), high(O), and3(I1,I2,I3,O). 				   
gate(O) :- and3(I1,I2,I3,O).

%%% and4
:- not ab(O), not high(O), high(I1), high(I2), high(I3), high(I4),
                   and4(I1,I2,I3,I4,O).
:- not ab(O), not high(I1), high(O), and4(I1,I2,I3,I4,O). 				   
:- not ab(O), not high(I2), high(O), and4(I1,I2,I3,I4,O). 				   
:- not ab(O), not high(I3), high(O), and4(I1,I2,I3,I4,O). 				   
:- not ab(O), not high(I4), high(O), and4(I1,I2,I3,I4,O). 				   
gate(O) :- and4(I1,I2,I3,I4,O).

%%% and5
:- not ab(O), not high(O), high(I1), high(I2), high(I3), high(I4), high(I5),
                   and5(I1,I2,I3,I4,I5,O).
:- not ab(O), not high(I1), high(O), and5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(I2), high(O), and5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(I3), high(O), and5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(I4), high(O), and5(I1,I2,I3,I4,I5,O). 				   
:- not ab(O), not high(I5), high(O), and5(I1,I2,I3,I4,I5,O). 				   
gate(O) :- and5(I1,I2,I3,I4,I5,O).

%%% and8
:- not ab(O), not high(O), high(I1), high(I2), high(I3), high(I4), high(I5), high(I6), high(I7), high(I8), 
                   and8(I1,I2,I3,I4,I5,I6,I7,I8,O).
:- not ab(O), not high(I1), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
:- not ab(O), not high(I1), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
:- not ab(O), not high(I2), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
:- not ab(O), not high(I3), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
:- not ab(O), not high(I4), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
:- not ab(O), not high(I5), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
:- not ab(O), not high(I6), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
:- not ab(O), not high(I7), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
:- not ab(O), not high(I8), high(O), and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   
gate(O) :- and8(I1,I2,I3,I4,I5,I6,I7,I8,O). 				   

%%% and9
:- not ab(O), not high(O), high(I1), high(I2), high(I3), high(I4), high(I5), high(I6), high(I7), high(I8), high(I9), 
                   and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O).
:- not ab(O), not high(I1), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O). 				   
:- not ab(O), not high(I2), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O). 				   
:- not ab(O), not high(I3), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O). 				   
:- not ab(O), not high(I4), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O). 				   
:- not ab(O), not high(I5), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O). 				   
:- not ab(O), not high(I6), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O). 				   
:- not ab(O), not high(I7), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O). 				   
:- not ab(O), not high(I8), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O).
:- not ab(O), not high(I9), high(O), and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O).
gate(O) :- and9(I1,I2,I3,I4,I5,I6,I7,I8,I9,O). 				   
