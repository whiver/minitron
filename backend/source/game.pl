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


% On arrive à la fin du jeu dès que l'un des joueurs essaye de sortir du plateau, ou dès qu'il marche sur ça trainé ou celle de
% l'autre joueur

out(X,Y,N) :- X>N, !.
out(X,Y,N) :- Y>N, !.
out(X,Y,N) :- X<1, !. 
out(X,Y,N) :- Y<1, !.

% Les deux mouvements sont Out
winner(Board,[X1,Y1], [X2,Y2],'Match nul') :-  dim(N), out(X1,Y1,N), out(X2,Y2,N). 
% Le 1 est Out, le 2 est à bon.
winner(Board,[X1,Y1], [X2,Y2],'2') :-  dim(N), out(X1,Y1,N), not(out(X2,Y2,N)), matrice(X2,Y2,Board,N2), var(N2).
% Le 2 est Out, le 1 n'est bon.
winner(Board,[X1,Y1], [X2,Y2],'1') :-  dim(N), out(X2,Y2,N), not(out(X1,Y1,N)), matrice(X1,Y1,Board,N1), var(N1).
% Le 2 est Out, le 1 est dedans mais a percuté 1 ou 2
winner(Board,[X1,Y1], [X2,Y2],'Match nul') :-  dim(N), out(X2,Y2,N), not(out(X1,Y1,N)), matrice(X1,Y1,Board,N1), nonvar(N1).
% Le 1 est Out, le 2 est dedans mais a percuté 1 ou 2
winner(Board,[X1,Y1], [X2,Y2],'Match nul') :-  dim(N), out(X1,Y1,N), not(out(X2,Y2,N)), matrice(X2,Y2,Board,N2), nonvar(N2).
% Les deux sont dedans, les deux ont percuté 1 ou 2 
winner(Board,[X1,Y1], [X2,Y2],'Match nul') :- matrice(X1,Y1,Board,N1), nonvar(N1),matrice(X2,Y2,Board,N2), nonvar(N2).
% 2 a percuté, et pas 1
winner(Board,[X1,Y1], [X2,Y2],'1') :- matrice(X2,Y2,Board,N2), nonvar(N2), matrice(X1,Y1,Board,N1), var(N1).
% 1 a percuté, et pas 2
winner(Board,[X1,Y1], [X2,Y2],'2') :- matrice(X1,Y1,Board,N1), nonvar(N1), matrice(X2,Y2,Board,N2), var(N2).

is1or2([]).
is1or2([T|Q]) :- nonvar(T),(T=1; T=2), is1or2(Q).

gameOver(Board) :- is1or2(Board), writeln('Match nul').
gameOver(Move1,Move2) :- board(Board,_,_),winner(Board,Move1,Move2,W),writeln('GAME OVER\nLe Gagnant est : '+W).

play :- writeln('\33\[2J'),
    		board(Board, Head1, Head2), % instanciate the board from the knowledge base 
       		not(gameOver(Board)), % Teste si le plateau n'est pas rempli
       		displayBoard,!, % print it
           	ia(Board, Move1,Head1), % ask the AI for a move, that is, an index for the Player 
    	    ia(Board, Move2,Head2),
    	    not(gameOver(Move1,Move2)), % Teste si le prochain mouvement ne provoque pas la fin du jeu
    		playMoves(Board, Move1, Move2, NewBoard), % Play the move and get the result in a new Board
    		applyIt(Board, Head1, Head2, NewBoard, Move1, Move2), % Remove the old board from the KB and store the new one
			sleep(0.5),
			play.


