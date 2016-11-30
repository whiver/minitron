test_iaRandom2 :- 	clean,
					init_iaRandom2,
					test_free,
					test_isInSet2,
					test_whichSet2,
					test_nextMove2,
					test_iaR2.

% Crée un environement pour le test
init_iaRandom2 :- 	assert(dim(10)),		
					% Remplit des cases par des 1 ou des 2 
					% Pour dire qu'elles appartiennent au joueur1 ou 2 
			    	matrice(5, 5, Board, 1),matrice(8, 8, Board, 2),matrice(4, 3, Board, 1),
			    	matrice(1, 2, Board, 2),matrice(2, 2, Board, 2),matrice(3, 2, Board, 2),
					matrice(2, 1, Board, 2),matrice(2, 3, Board, 2),matrice(3, 4, Board, 2),
					% Initialisation de Board
				    initList(Board, 100),
				    assert(board(Board, [5, 5], [8, 8])).

% Teste si une case de Board est vide
test_free :- 	board(Board,_,_),          		% Récupère le Board
				not(free(Board, 5, 5)),			% Vérifie que la tête du joueur1 n'est pas vide
				not(free(Board, 8, 8)),			% Vérifie que la tête du joueur2 n'est pas vide
				free(Board, 1, 10),				% Vérifie qu'une case qui n'appartient ni au joueur1
												% ni au joueur2 est vide
				not(free(Board, 0, 2)), 		% Vérifie qu'une case correspendant au mur n'est 
				not(free(Board, 11, 2)).		% pas une case vide

% Teste si une case est candidate auquel cas elle est mise dans une liste dont elle est le seul élément
% Sinon une liste vide est retournée
test_isInSet2 :- 	board(Board,_,_),			% Récupère le Board
					isInSet2(Board,5,5,[0],0),	% Vérifie qu'en partant de [5,5] la case [4,5] est candidate
					isInSet2(Board,5,5,[1],1),	% Vérifie qu'en partant de [5,5] la case [5,6] est candidate
					isInSet2(Board,5,5,[2],2),	% Vérifie qu'en partant de [5,5] la case [6,5] est candidate
					isInSet2(Board,5,5,[3],3),	% Vérifie qu'en partant de [5,5] la case [5,4] est candidate
					isInSet2(Board,8,7,[],1),	% Vérifie qu'en partant de [8,7] la case [8,8] 
												% occupée par le joueur2 n'est pas candidate
					isInSet2(Board,5,4,[],1),	% Vérifie qu'en partant de [5,4] la case [4,5]
												% occupée par le joueur1
												% n'est pas candidate 
					isInSet2(Board,3,1,[],3).   % Vérifie qu'en partant de [3,1] la case [3,0]
												% correspendant au mur 
												% n'est pas candidate 

% Vérifie la liste des cases candidates partant d'une case donnée
test_whichSet2 :- 	board(Board,_,_),					% Récupère le Board
					whichSet2(Board,5,5,[0,1,2,3]),		% Vérifie que toutes les cases sont candidates
					whichSet2(Board,5,4,[0,2,3]),		% Vérifie que la case [5,5] occupée par le joueur1 
														% n'est pas candidate
					whichSet2(Board,3,3,[]),			% Vérifie qu'il n'y a aucune case candidate partant de [3,3]
														% [4,3] est occupée par le joueur1 
														% les autres cases par le joueur2
					whichSet2(Board,2,2,[]),			% Vérifie qu'il n'y a aucune case candidate partant de [2,2]
														% Toutes les cases sont occupées par le joueur2
					whichSet2(Board,3,1,[2]).			% Vérifie que la seule case candidate
														% partant de [3,1] est [4,1], [3,0] étant le mur

% Teste que la prochaine case choisie est valide
test_nextMove2 :- 	board(Board,_,_),	% Récupère le Board
					% Toutes les cases autour de [5,5] sont vides
					nextMove2(Board,5,5,X,Y),					 
						((X is 5, (Y is 4; Y is 6));
							(Y is 5, (X is 4; X is 6))),
					% Une case appartient au joueur 2 
					% Le reste des cases sont vides
					nextMove2(Board,8,7,X1,Y1),
						((X1 is 8, Y1 is 6);
							(Y1 is 7, (X1 is 7; X1 is 9))),
					% Toutes les cases sont remplies, l'ia choisit n'importe quelle case des 4 l'entourant
					% Eventuellement le mur
					nextMove2(Board,2,2,X2,Y2),
						((X2 is 2, (Y2 is 1; Y2 is 3));
							(Y2 is 2, (X2 is 1; X2 is 3))),
					% Une case est occupée par le joueur1 et le reste par le joueur2
					nextMove2(Board,3,3,X3,Y3),
						((X3 is 3, (Y3 is 2; Y3 is 4));
							(Y3 is 3, (X3 is 2; X3 is 4))),
					% Une seule case libre, [3,0] est le mur
					nextMove2(Board,3,1,4,1). 

% Teste que la prochaine case choisie par l'IA est valide
test_iaR2 :- 		board(Board,_,_),
					% Toutes les cases autour de [5,5] sont vides
					iaRandom2(Board, [X,Y],[5,5]),
						((X is 5, (Y is 4; Y is 6));
							(Y is 5, (X is 4; X is 6))),
					% Une case appartient au joueur 2 
					% Le reste des cases sont vides
					iaRandom2(Board, [X1,Y1],[8,7]),
						((X1 is 8, Y1 is 6);
							(Y1 is 7, (X1 is 7; X1 is 9))),
					% Toutes les cases sont remplies, l'ia choisit n'importe quelle case des 4 l'entourant
					% Eventuellement le mur
					iaRandom2(Board, [X2,Y2],[2,2]),
					((X2 is 2, (Y2 is 1; Y2 is 3));
								(Y2 is 2, (X2 is 1; X2 is 3))),
					% Une case est occupée par le joueur1 et le reste par le joueur2
					iaRandom2(Board,[X3,Y3],[3,3]),
						((X3 is 3, (Y3 is 2; Y3 is 4));
							(Y3 is 3, (X3 is 2; X3 is 4))),
					% Une seule case libre, [3,0] est le mur
					iaRandom2(Board,[4,1],[3,1]). 