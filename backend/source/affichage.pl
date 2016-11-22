
%Affiche toute la board
displayBoard :- board(Board, _, _), displayElem(Board, 0).

%Affiche un élément et lance l’affichage de l'élément suivant
displayElem([], _).
displayElem([H|T], I) :- dim(D), I is D-1, ((nonvar(H), writeln(H)); writeln(0)), displayElem(T, 0).
displayElem([H|T], I) :- ((nonvar(H), write(H)); write(0)), succ(I, Next), displayElem(T, Next).


