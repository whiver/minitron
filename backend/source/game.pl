% Applique les 2 coups sur une nouvelle board (NewBoard)
% arg1 -> Ancienne board
% arg2 -> Nouvelles coordonnées de la tête du joueur 1
% arg3 -> Nouvelles coordonnées de la tête du joueur 2
% arg4 -> Nouvelle board
playMoves(Board, [X1,Y1], [X2,Y2], NewBoard) :- Board = NewBoard, matrice(X1, Y1, NewBoard, 1), matrice(X2, Y2, NewBoard, 2).

% Supprime l'ancienne board et les anciennes têtes, instancie la nouvelle board
% arg1 -> Ancienne board
% arg2 -> Ancienne tete joueur 1
% arg3 -> Ancienne tete joueur 2
% arg1 -> Nouvelle board
% arg2 -> Nouvelle tete joueur 1
% arg3 -> Nouvelle tete joueur 2
applyIt(Board, Head1, Head2, NewBoard, NewHead1, NewHead2) :- retract(board(Board, Head1, Head2)), assert(board(NewBoard, NewHead1, NewHead2)).


is1or2([]).
is1or2([T|Q]) :- nonvar(T),(T=1; T=2), is1or2(Q).

gameOver :- board(Board,_,_),is1or2(Board).

play :- gameOver.
play :- write('\33\[2J'),
    		board(Board, Head1, Head2), % instanciate the board from the knowledge base 
       		displayBoard, % print it
           	ia(Board, Move1,Head1), % ask the AI for a move, that is, an index for the Player 
    	    ia(Board, Move2,Head2),
    		playMoves(Board, Move1, Move2, NewBoard), % Play the move and get the result in a new Board
    		applyIt(Board, Head1, Head2, NewBoard, Move1, Move2), % Remove the old board from the KB and store the new one
			sleep(0.5),
			play.

%Init pourrav pour tester
init :- assert(dim(10)),
	dim(D), N is D*D, %Calcul des dimensions
	X1 is 1, Y1 is 1, X2 is 10, Y2 is 10, %définition des points des 2 têtes
	matrice(X1, Y1, Board, 1), matrice(X2, Y2, Board, 2), %Placement des têtes dans la matrice
	initList(Board, N), %initialisation du reste de la matrice avec des 0
	assert(board(Board, [X1, Y1], [X2, Y2])), %assertion du fait board
	displayBoard, %Affichage (Remplacer plus tard par le lancement du jeu)
	play.
