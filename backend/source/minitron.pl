%%% MiniTron %%%

%Pour recuperer un element d une liste vue comme une matrice

dim(3). %On ne prendra que des matrice carrees

operation(X,Y,R) :- dim(D), R is ((X*D)+Y).
matrice(X,Y,List, Element) :- operation((X-1),(Y-1),R), nth0( R, List, Element, _).

