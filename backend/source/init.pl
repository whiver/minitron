%Init pourrav pour tester
init :- assert(dim(10)),
	dim(D), N is D*D, %Calcul des dimensions
	X1 is 5, Y1 is 5, X2 is 8, Y2 is 8, %définition des points des 2 têtes
	matrice(X1, Y1, Board, 1), matrice(X2, Y2, Board, 2), %Placement des têtes dans la matrice
	initList(Board, N), %initialisation du reste de la matrice avec des 0
	assert(board(Board, [X1, Y1], [X2, Y2])), %assertion du fait board
	displayBoard, %Affichage (Remplacer plus tard par le lancement du jeu)
	not(play).

% Initialisation 2
% Ne mettre que les têtes représentatnt les deux joueurs
initList(List, Size) :- length(List,Size). 

clean :-
    retractall(dim(_)),
    retractall(board(_,_,_)),
    retractall(playerAI(_,_)).

start(BoardSize,
	    [P1X, P1Y],
      [P2X, P2Y],
      P1AI,
      P2AI) :-
    clean,
    assert(dim(BoardSize)),
    matrice(P1X, P1Y, Board, 1), matrice(P2X, P2Y, Board, 2),
    BoardTotalSize is BoardSize * BoardSize,
    initList(Board, BoardTotalSize),
    assert(board(Board, [P1X, P1Y], [P2X, P2Y])),
    assert(playerAI(1, P1AI)),
    assert(playerAI(2, P2AI)).
