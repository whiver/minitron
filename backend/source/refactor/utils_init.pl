%%% MiniTron %%%

:- dynamic board/3, dim/1. % permet l'assertion et le retrait de faits board/3 (Board + les 2 têtes)

%On ne prendra que des matrice carrees
 


%Pour recuperer un element d une liste vue comme une matrice
extraire(X,Y,R) :- dim(D), R is ((X*D)+Y).
% TODO : ATTENTION : ici X est associe à "X-1", et Y à "Y-1" pour des appels plus "naturels", à discuter
matrice(X,Y,List, Element) :- extraire((X-1),(Y-1),R), nth0( R, List, Element, _).

%Initialise une liste avec N valeurs V (Besoin de refactor ?)
initList(_, [], 0).
initList(V, [H | Tail], N) :- (H is V; H is 1; H is 2), Prec is N-1, initList(V, Tail, Prec).

% Initialisation 2
% Ne mettre que les têtes représentatnt les deux joueurs
initList(List, Size) :- length(List,Size). 

