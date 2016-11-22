
% Applique les 2 coups sur une nouvelle board (NewBoard)
% Move1 -> Nouvelles coordonnées de la tête du joueur 1
% Move2 -> Nouvelles coordonnées de la tête di joueur 2
% Completement daubée ! TODO : Trouver un moyen de copier Board dans NewBoard, sauf pour les 2 nouveaux points.
playMoves(Board, [X1,Y1], [X2,Y2], NewBoard) :- Board = NewBoard, matrice(X1, Y1, NewBoard, 1), matrice(X2, Y2, NewBoard, 2).

% Supprime l'ancienne board et les anciennes têtes, instancie la nouvelle board
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


