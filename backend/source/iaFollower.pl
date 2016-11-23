% IA qui prends toujours une direction adjacente à l'un des obstacles voisins.

% Teste si une case est considerée comme un obstacle
% arg1 -> Coordonnée X
% arg2 -> Coordonnée Y
estObstacle(_,X,Y) :- dim(D), ( X =< 0 ; Y =< 0 ; X >= (D+1) ; Y >= (D+1)).
estObstacle(Board,X,Y) :- matrice(X,Y,Board,Elem), nonvar(Elem), (Elem is 1; Elem is 2). 

% si obstacle en haut, on tente la gauche ou la droite
iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- estObstacle(Board, X-1, Y), ((not(estObstacle(Board, X, Y-1)), MoveX is X, MoveY is Y-1); (not(estObstacle( Board,X, Y+1)), MoveX is X, MoveY is Y+1)).

% si obstacle en bas, on tente la gauche ou la droite
iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- estObstacle( Board,X+1, Y), ((not(estObstacle( Board,X, Y-1)), MoveX is X, MoveY is Y-1); (not(estObstacle( Board,X, Y+1)), MoveX is X, MoveY is Y+1)).

% si obstacle a gauche, on tente haut ou bas
iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- estObstacle( Board,X, Y-1), ((not(estObstacle( Board,X-1, Y)), MoveX is X-1, MoveY is Y); (not(estObstacle( Board,X+1, Y)), MoveX is X+1, MoveY is Y)).

% si obstacle a droite, on tente haut ou bas
iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- estObstacle( Board,X, Y+1), ((not(estObstacle( Board,X-1, Y)), MoveX is X-1, MoveY is Y); (not(estObstacle( Board,X+1, Y)), MoveX is X+1, MoveY is Y)).

iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- true.