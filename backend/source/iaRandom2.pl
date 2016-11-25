% IA qui ne va que sur des cases libres 
% Il y a game over lorsque les deux IA choisissent la même case
% Lorsque l'IA est entourée par des cases remplies et/ou le mur 
% Elle choisit une des cases par hazard (Ce qui déclanche un game over)

% Trouver les cases libres autour d'une case
free(Board,X,Y) :- dim(N),not(out(X,Y,N)), matrice(X, Y, Board, Val), var(Val).

isInSet2(Board,X,Y,[Head],Head) :- move(Head,X,Y,NewX,NewY), free(Board,NewX,NewY).
isInSet2(Board,X,Y,[],Head) :- move(Head,X,Y,NewX,NewY), not(free(Board,NewX,NewY)).

whichSet2(Board,X,Y,Set) :- isInSet2(Board,X,Y,S0,0),isInSet2(Board,X,Y,S1,1),
			isInSet2(Board,X,Y,S2,2),isInSet2(Board,X,Y,S3,3), union(S0,S1,S01), 
			union(S01,S2,S012), union(S012,S3,Set).

% IA calculant le prochain déplacement 
nextMove2(Board,X,Y,NewX,NewY) :- whichSet2(Board,X,Y,Set),random_member(N,Set), move(N,X,Y,NewX,NewY).
nextMove2(Board,X,Y,NewX,NewY) :- whichSet2(Board,X,Y,Set),Set = [], random_member(N,[0,1,2,3]), move(N,X,Y,NewX,NewY).

iaRandom2(Board, [M1,M2],[P1,P2]) :- dim(N),nextMove2(Board,P1,P2,M1,M2).
