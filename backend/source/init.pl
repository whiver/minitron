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
