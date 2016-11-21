%%% MiniTron %%%

:- dynamic board/3. % permet l'assertion et le retrait de faits board/3 (Board + les 2 têtes)

%On ne prendra que des matrice carrees
dim(10). 


%Pour recuperer un element d une liste vue comme une matrice
extraire(X,Y,R) :- dim(D), R is ((X*D)+Y).
% TODO : ATTENTION : ici X est associe à "X-1", et Y à "Y-1" pour des appels plus "naturels", à discuter
matrice(X,Y,List, Element) :- extraire((X-1),(Y-1),R), nth0( R, List, Element, _).

%Initialise une liste avec N valeurs V (Besoin de refactor ?)
initList(_, [], 0).
initList(V, [H | Tail], N) :- (H is V; H is 1; H is 2), Prec is N-1, initList(V, Tail, Prec).


%Affiche toute la board
displayBoard :- board(Board, _, _), displayElem(Board, 0).

%Affiche un élément et lance l’affichage de l'élément suivant
displayElem([], _).
displayElem([H|T], I) :- dim(D), I is D-1, writeln(H), displayElem(T, 0).
displayElem([H|T], I) :- write(H), succ(I, Next), displayElem(T, Next).


% IA triviale
% avec par ex. 1 : tourner à gauche
%			   2 : aller tout droit
%			   3 : tourner à droite
iaRandom(Low, High, Resultat) :-  random_between(Low, High, Resultat).

%Echoue ou reussi selon que la position soit occupee ou non.
positionValide(X, Y) :- board(Board,_,_), matrice(X,Y,Board, Element) , Element == 0.




%Attention, C EST FOIREUX, methode peut etre pas bonne.
checkHaut(X, Y, Xsol, Ysol) :- Xsol is (X-1), Ysol is (Y), positionValide(Xsol, Ysol).
checkBas(X, Y, Xsol, Ysol) :- Xsol is (X+1), Ysol is (Y), positionValide(Xsol, Ysol).




%play :- write('New turn'),
%    		board(Board), % instanciate the board from the knowledge base 
%       	    displayBoard, % print it
%            ia(Board, Move1,Player1), % ask the AI for a move, that is, an index for the Player 
%    	    ia(Board, Move2,Player2),
%    		playMoves(Board,Move1,Move2,NewBoard), % Play the move and get the result in a new Board
%    		applyIt(Board, NewBoard), % Remove the old board from the KB and store the new one
%			play.

%Init pourrav pour tester
init :- dim(D), N is D*D, %Calcul des dimensions
	X1 is 1, Y1 is 1, X2 is 10, Y2 is 10, %définition des points des 2 têtes
	matrice(X1, Y1, Board, 1), matrice(X2, Y2, Board, 2), %Placement des têtes dans la matrice
	initList(0, Board, N), %initialisation du reste de la matrice avec des 0
	assert(board(Board, [X1, Y1], [X2, Y2])), %assertion du fait board
	displayBoard. %Affichage (Remplacer plus tard par le lancement du jeu)

