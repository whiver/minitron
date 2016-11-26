:- dynamic board/3, dim/1, playerAI/2. % permet l'assertion et le retrait de faits board/3 (Board + les 2 têtes)

%Pour recuperer un element d une liste vue comme une matrice
extraire(X,Y,R) :- dim(D), R is ((X*D)+Y).

% TODO : ATTENTION : ici X est associe à "X-1", et Y à "Y-1" pour des appels plus "naturels", à discuter
matrice(X,Y,List, Element) :- extraire((X-1),(Y-1),R), nth0( R, List, Element, _).