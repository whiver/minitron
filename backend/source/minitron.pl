%%% MiniTron %%%

%Pour recuperer un element d une liste vue comme une matrice (!! ici la dimension 3 est en dur)
operation(X,Y,R) :- R is ((X*3)+Y).
matrice(X,Y,List, Element) :- operation((X-1),(Y-1),R), nth0( R, List, Element, _).
