test :- test_init,
		test_mien,
		test_isInSet,
		test_whichSet,
		test_nextMove,
		test_ia.

test_init :- assert(dim(10)),
	dim(D), N is D*D, %Calcul des dimensions
	X1 is 5, Y1 is 5, X2 is 8, Y2 is 8, %définition des points des 2 têtes
	matrice(X1, Y1, Board, 1), matrice(X2, Y2, Board, 2), %Placement des têtes dans la matrice
	matrice(1,2, Board, 2),matrice(2,2, Board, 2),matrice(3,2, Board, 2),
	matrice(2,1, Board, 2),matrice(2,3, Board, 2),matrice(3,4, Board, 2), %Autres initialisations
	initList(Board, N), %initialisation du reste de la matrice avec des 0
	assert(board(Board, [X1, Y1], [X2, Y2])). %assertion du fait board


test_mien :- board(Board,_,_),
			mien(Board, 5, 5, 1),
			not(mien(Board, 5, 5, 2)),
			mien(Board, 8, 8, 2),
			not(mien(Board, 8, 8, 1)),
			not(mien(Board, 1, 10, 1)),
			not(mien(Board, 1, 10, 2)).

test_isInSet :- board(Board,_,_),
				isInSet(Board,5,5,1,[0],0),
				isInSet(Board,5,5,1,[1],1),
				isInSet(Board,5,5,1,[2],2),
				isInSet(Board,5,5,1,[3],3),
				isInSet(Board,8,7,1,[1],1),
				isInSet(Board,5,4,1,[],1).
test_whichSet :- board(Board,_,_),
				whichSet(Board,5,5,1,[0,1,2,3]),
				whichSet(Board,5,4,1,[0,2,3]),
				whichSet(Board,5,4,2,[0,1,2,3]),
				whichSet(Board,3,3,2,[2]),
				whichSet(Board,2,2,2,[]).
test_nextMove :- board(Board,_,_),
				nextMove(Board,5,5,X,Y,1),
					((X is 5, (Y is 4; Y is 6));
						(Y is 5, (X is 4; X is 6))),
				% Une case remplie à 2 et le Player est 1
				nextMove(Board,8,7,X1,Y1,1),
					((X1 is 8, (Y1 is 8; Y1 is 6));
						(Y1 is 7, (X1 is 7; X1 is 9))),
				% Cas où toutes les cases sont remplies, l'ia doit choisir une case quand même
				nextMove(Board,2,2,X2,Y2,2),
					((X2 is 2, (Y2 is 1; Y2 is 3));
						(Y2 is 2, (X2 is 1; X2 is 3))),
				% Test avec une seule case de libre
				nextMove(Board,3,3,X3,Y3,2),X3 is 4,Y3 is 3.
test_ia :- board(Board,_,_),
			ia(Board, [X,Y],[5,5],1),
			((X is 5, (Y is 4; Y is 6));
						(Y is 5, (X is 4; X is 6))),
			ia(Board, [X1,Y1],[8,7],1),
			((X1 is 8, (Y1 is 8; Y1 is 6));
						(Y1 is 7, (X1 is 7; X1 is 9))),
			ia(Board, [X2,Y2],[2,2],2),
			((X2 is 2, (Y2 is 1; Y2 is 3));
						(Y2 is 2, (X2 is 1; X2 is 3))),
			ia(Board, [X3,Y3],[3,3],2), X3 is 4,Y3 is 3.