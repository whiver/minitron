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

% Joue une itération du jeu => n'est pas récursive
playStep :- gameOver.
playStep :- 
	%write('\33\[2J'),
	board(Board, Head1, Head2), % instanciate the board from the knowledge base 
   	ia(Board, Move1,Head1), % ask the AI for a move, that is, an index for the Player 
    ia(Board, Move2,Head2),
	playMoves(Board, Move1, Move2, NewBoard), % Play the move and get the result in a new Board
	applyIt(Board, Head1, Head2, NewBoard, Move1, Move2). % Remove the old board from the KB and store the new one
	%displayBoard. % print it
