% IA qui prends toujours une direction adjacente à l'un des obstacles voisins.

% Teste si une case est considerée comme un obstacle
% arg1 -> Coordonnée X
% arg2 -> Coordonnée Y
estObstacle(_,X,Y) :- dim(D), A is X, B is Y, ( A =< 0 ; B =< 0 ; A >= (D+1) ; B >= (D+1)), !.
estObstacle(Board,X,Y) :- matrice(X,Y,Board,Elem), nonvar(Elem), (Elem is 1; Elem is 2). 

% si obstacle en haut, on tente la gauche ou la droite
iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- estObstacle(Board, X-1, Y), ((not(estObstacle(Board, X, Y-1)), MoveX is X, MoveY is Y-1); (not(estObstacle( Board,X, Y+1)), MoveX is X, MoveY is Y+1)).

% si obstacle en bas, on tente la gauche ou la droite
iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- estObstacle( Board,X+1, Y), ((not(estObstacle( Board,X, Y-1)), MoveX is X, MoveY is Y-1); (not(estObstacle( Board,X, Y+1)), MoveX is X, MoveY is Y+1)).

% si obstacle a gauche, on tente haut ou bas
iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- estObstacle( Board,X, Y-1), ((not(estObstacle( Board,X-1, Y)), MoveX is X-1, MoveY is Y); (not(estObstacle( Board,X+1, Y)), MoveX is X+1, MoveY is Y)).

% si obstacle a droite, on tente haut ou bas
iaFollower(Board, [MoveX,MoveY|_], [X,Y|_]) :- estObstacle( Board,X, Y+1), ((not(estObstacle( Board,X-1, Y)), MoveX is X-1, MoveY is Y); (not(estObstacle( Board,X+1, Y)), MoveX is X+1, MoveY is Y)).

% TODO : discuter : le rendre independant en copiant le code d ia Random 2 ?

% Copie d'ia Random si jamais il n y a pas d'obstacle a suivre
iaFollower(Board, [M1,M2],[P1,P2]) :- iaRandom2(Board, [M1,M2],[P1,P2]).
