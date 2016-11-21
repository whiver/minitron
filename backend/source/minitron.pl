%%% MiniTron %%%

:- dynamic board/1. % permet l'assertion et le retrait de faits board/1

%Pour recuperer un element d une liste vue comme une matrice

dim(10). %On ne prendra que des matrice carrees

operation(X,Y,R) :- dim(D), R is ((X*D)+Y).
matrice(X,Y,List, Element) :- operation((X-1),(Y-1),R), nth0( R, List, Element, _).

%Initialise une liste avec N valeurs V
initList(_, [], 0).
initList(V, [V | Tail], N) :- Prec is N-1, initList(V, Tail, Prec).


%Affiche toute la board
displayBoard :- board(Board), displayElem(Board, 0).


%Affiche un élément et lance l’affichage de l'élément suivant
displayElem([], _).
displayElem([H|T], I) :- dim(D), I is D-1, writeln(H), displayElem(T, 0).
displayElem([H|T], I) :- write(H), succ(I, Next), displayElem(T, Next).


%Init pourrav pour tester
init :- dim(D), N is D*D, initList(0, Board, N), assert(board(Board)), displayBoard.

