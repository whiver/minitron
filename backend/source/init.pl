% Initialisation 2
% Ne mettre que les têtes représentatnt les deux joueurs
initList(List, Size) :- length(List,Size). 

% Retire de la base de faits les prédicats dynamiques instanciés
clean :-
    retractall(dim(_)),
    retractall(board(_,_,_)),
    retractall(playerAI(_,_)).

% Démarre (ou redémarre) une partie, sans la jouer
% BoardSize -> Taille d'un côté du plateau (le plateau est un carré)
% [P1X, P1Y] -> Position de départ du joueur 1
% [P2X, P2Y] -> Position de départ du joueur 2
% P1AI -> IA du joueur 1 (ex: 'AI_FOLLOWER', 'AI_RANDOM2')
% P1AI -> IA du joueur 2 (ex: 'AI_FOLLOWER', 'AI_RANDOM2')
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
