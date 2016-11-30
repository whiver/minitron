% L'IA choisit une case aléatoirement parmis un ensemble de cases candidates
% Les cases candidates sont recherchées parmis les 4 cases entourant la tête
% 		- Elles n'appartiennent à aucun joueur
%		- Ce ne sont pas des cases hors Board qui correspendent au mur
% Dans le cas ou l'IA se retrouve emprisonnée, elle choisit aléatoirement 
% L'une des quatre cases l'entourant éventuellement le mur

% Associe un numéro à chacune des 4 cases entourant une case
move(0,X,Y,NewX,NewY) :- NewX is X-1, NewY is Y.
move(1,X,Y,NewX,NewY) :- NewX is X, NewY is Y+1.
move(2,X,Y,NewX,NewY) :- NewX is X+1, NewY is Y.
move(3,X,Y,NewX,NewY) :- NewX is X, NewY is Y-1.

% Vérifie si une case est vide et que ce n'est pas une case du mur
free(Board,X,Y) :- dim(N),not(out(X,Y,N)), matrice(X, Y, Board, Val), var(Val).

% Vérifie que la case correspendant au numéro est vide 
% et retourne une liste qui a pour seul élément le numéro en question
% Retourne une liste vide dans le cas où la case spécifiée n'est pas vide
isInSet2(Board,X,Y,[Head],Head) :- move(Head,X,Y,NewX,NewY), free(Board,NewX,NewY).
isInSet2(Board,X,Y,[],Head) :- move(Head,X,Y,NewX,NewY), not(free(Board,NewX,NewY)).

% Retourne une liste des cases candidates (vides) entourants une case
whichSet2(Board,X,Y,Set) :- isInSet2(Board,X,Y,S0,0),isInSet2(Board,X,Y,S1,1),
			isInSet2(Board,X,Y,S2,2),isInSet2(Board,X,Y,S3,3), union(S0,S1,S01), 
			union(S01,S2,S012), union(S012,S3,Set).

% Choisit aléatoirement une case parmis une liste de cases candidates 
nextMove2(Board,X,Y,NewX,NewY) :- whichSet2(Board,X,Y,Set),random_member(N,Set), move(N,X,Y,NewX,NewY).
nextMove2(Board,X,Y,NewX,NewY) :- whichSet2(Board,X,Y,Set),Set = [], random_member(N,[0,1,2,3]), move(N,X,Y,NewX,NewY).

% Détermine la prochaine case à jouer 
iaRandom2(Board, [M1,M2],[P1,P2]) :- nextMove2(Board,P1,P2,M1,M2).
