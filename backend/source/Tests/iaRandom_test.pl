test_iaRandom :- 	clean,
					init_iaRandom,
					test_mien,
					test_isInSet,
					test_whichSet,
					test_nextMove,
					test_iaR.

% Crée un environement pour le test
init_iaRandom :- 	assert(dim(10)),		
					% Remplit des cases par des 1 ou des 2 
					% Pour dire qu'elles appartiennent au joueur1 ou 2 
			    	matrice(5, 5, Board, 1),matrice(8, 8, Board, 2),matrice(4, 3, Board, 1),
			    	matrice(1, 2, Board, 2),matrice(2, 2, Board, 2),matrice(3, 2, Board, 2),
					matrice(2, 1, Board, 2),matrice(2, 3, Board, 2),matrice(3, 4, Board, 2),
					% Initialisation de Board
				    initList(Board, 100),
				    assert(board(Board, [5, 5], [8, 8])).

% Teste si une case de Board apparient ou pas à un player
test_mien :- board(Board,_,_),          	% Récupère le Board
			mien(Board, 5, 5, 1),			% Vérifie que la tête du joueur1 lui appartient bien
			not(mien(Board, 5, 5, 2)),		% Vérifie que la tête du joueur1 n'appartient pas au joueur2
			mien(Board, 8, 8, 2),			% Vérifie que la tête du joueur2 lui appartient bien
			not(mien(Board, 8, 8, 1)),		% Vérifie que la tête du joueur2 n'appartient pas au joueur1
			not(mien(Board, 1, 10, 1)),		% Vérifie qu'une case vide n'appartient ni au joueur1
			not(mien(Board, 1, 10, 2)).		% Ni au joueur2

% Teste si une case est candidate auquel cas elle est mise dans une liste dont elle est le seul élément
% Sinon une liste vide est retournée
test_isInSet :- board(Board,_,_),			% Récupère le Board
				isInSet(Board,5,5,1,[0],0),	% Vérifie qu'en partant de [5,5] la case [4,5] 
											% est candidate pour le joueur1
				isInSet(Board,5,5,1,[1],1),	% Vérifie qu'en partant de [5,5] la case [5,6] 
											% est candidate pour le joueur1
				isInSet(Board,5,5,1,[2],2),	% Vérifie qu'en partant de [5,5] la case [6,5] 
											% est candidate pour le joueur1
				isInSet(Board,5,5,1,[3],3),	% Vérifie qu'en partant de [5,5] la case [5,4] 
											% est candidate pour le joueur1
				isInSet(Board,8,7,1,[1],1),	% Vérifie qu'en partant de [8,7] la case [8,8] 
											% occupée par le joueur2 
											% est candidate pour le joueur1
				isInSet(Board,5,4,1,[],1).	% Vérifie qu'en partant de [5,4] la case [4,5]
											% occupée par le joueur1
											% n'est pas candidate pour lui même

% Retourne la liste des cases candidates pour un joueur donné partant d'une case donnée
test_whichSet :- board(Board,_,_),					% Récupère le Board
				whichSet(Board,5,5,1,[0,1,2,3]),	% Vérifie que toutes les cases sont candidates
				whichSet(Board,5,4,1,[0,2,3]),		% Vérifie que la case [5,5] occupée par le joueur1 
													% n'est pas candidate
				whichSet(Board,5,4,2,[0,1,2,3]),	% Vérifie que la case [5,5] occupée par le joueur1
													% est candidate pour le joueur2
				whichSet(Board,3,3,2,[2]),			% Vérifie que le joueur deux n'a qu'une seule case candidate
													% Partant de [3,3] il ne peut aller que dans [4,3] 
													% Occupée par le joueur1
				whichSet(Board,2,2,2,[]),			% Vérifie que le joueur2 est pris au piège 
													% aucune case candidate
				whichSet(Board,3,1,2,[2,3]).		% Vérifie que les cases candidates pour le joueur2
													% partant de [3,1] sont [4,1] et le mur

% Teste que la prochaine case choisie est valide
test_nextMove :- board(Board,_,_),	% Récupère le Board
				% Toutes les cases autour de [5,5] sont vides
				nextMove(Board,5,5,X,Y,1),					 
					((X is 5, (Y is 4; Y is 6));
						(Y is 5, (X is 4; X is 6))),
				% Une case appartient au joueur 2 et le joueur est 1
				nextMove(Board,8,7,X1,Y1,1),
					((X1 is 8, (Y1 is 8; Y1 is 6));
						(Y1 is 7, (X1 is 7; X1 is 9))),
				% Toutes les cases sont remplies, l'ia choisit n'importe quelle case des 4 l'entourant
				% Eventuellement le mur
				nextMove(Board,2,2,X2,Y2,2),
					((X2 is 2, (Y2 is 1; Y2 is 3));
						(Y2 is 2, (X2 is 1; X2 is 3))),
				% Une seule case de libre 
				nextMove(Board,3,3,X3,Y3,2),X3 is 4,Y3 is 3.

% Teste que la prochaine case choisie par l'IA est valide
test_iaR :- board(Board,_,_),
			% Toutes les cases autour de [5,5] sont vides
			ia(Board, [X,Y],[5,5],1),
			((X is 5, (Y is 4; Y is 6));
						(Y is 5, (X is 4; X is 6))),
			% Une case appartient au joueur 2 et le joueur est 1
			ia(Board, [X1,Y1],[8,7],1),
			((X1 is 8, (Y1 is 8; Y1 is 6));
						(Y1 is 7, (X1 is 7; X1 is 9))),
			% Toutes les cases sont remplies, l'ia choisit n'importe quelle case des 4 l'entourant
			% Eventuellement le mur
			ia(Board, [X2,Y2],[2,2],2),
			((X2 is 2, (Y2 is 1; Y2 is 3));
						(Y2 is 2, (X2 is 1; X2 is 3))),
			% Une seule case de libre 
			ia(Board, [X3,Y3],[3,3],2), X3 is 4,Y3 is 3.