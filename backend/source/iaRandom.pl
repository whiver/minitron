% Description de l'IA
% L'IA choisit à chaque fois une case qui ne lui appartient pas 
% Elle peut choisir de sortir du plateau du jeu
% Dans le cas où toutes les cases autour de l'IA lui appartiennent 
% elle choisit l'une d'elles 
% Le choix des cases est aléatoire parmis les cases possibles
% Possible d'aller à droit et de resortir à gauche à la prochaine ligne ??????

% Les prochains déplacements possibles
move(0,X,Y,NewX,NewY) :- NewX is X-1, NewY is Y.
move(1,X,Y,NewX,NewY) :- NewX is X, NewY is Y+1.
move(2,X,Y,NewX,NewY) :- NewX is X+1, NewY is Y.
move(3,X,Y,NewX,NewY) :- NewX is X, NewY is Y-1.

% Trouver les cases libres autour d'une case
mien(Board,X,Y,Player) :- dim(N),not(out(X,Y,N)), matrice(X, Y, Board, Val), nonvar(Val), Val is Player.

isInSet(Board,X,Y,Player,[Head],Head) :- move(Head,X,Y,NewX,NewY), not(mien(Board,NewX,NewY,Player)).
isInSet(Board,X,Y,Player,[],Head) :- move(Head,X,Y,NewX,NewY), mien(Board,NewX,NewY,Player).

whichSet(Board,X,Y,Player,Set) :- isInSet(Board,X,Y,Player,S0,0),isInSet(Board,X,Y,Player,S1,1),
			isInSet(Board,X,Y,Player,S2,2),isInSet(Board,X,Y,Player,S3,3), union(S0,S1,S01), 
			union(S01,S2,S012), union(S012,S3,Set).

% IA calculant le prochain déplacement 
nextMove(Board,X,Y,NewX,NewY,Player) :- whichSet(Board,X,Y,Player,Set),random_member(N,Set), move(N,X,Y,NewX,NewY).
nextMove(Board,X,Y,NewX,NewY,Player) :- whichSet(Board,X,Y,Player,Set),Set = [], random_member(N,[0,1,2,3]), move(N,X,Y,NewX,NewY).

ia(Board, [M1,M2],[P1,P2],Player) :- dim(N),nextMove(Board,P1,P2,M1,M2,Player).
