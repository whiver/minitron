test_out :- not(out(3,5,10)), % Tester une case à l'intérieur
			not(out(3,5,10)), % 
			not(out(3,5,10)),
			not(out(3,5,10)),
			not(out(3,5,10)),
			not(out(3,5,10)),
			not(out(3,5,10)),
			not(out(3,5,10)),
			not(out(3,5,10)). 


test_game_over :- assert(dim(10)),
	dim(D), N is D*D, %Calcul des dimensions
	X1 is 5, Y1 is 5, X2 is 8, Y2 is 8, %définition des points des 2 têtes
	matrice(X1, Y1, Board, 1), matrice(X2, Y2, Board, 2), %Placement des têtes dans la matrice
	initList(Board, N), %initialisation du reste de la matrice avec des 0
	assert(board(Board, [X1, Y1], [X2, Y2])), %assertion du fait board

	not(gameOver([6, 6], [9,9])), % des cases vides
	gameOver([X1, Y1], [X2, Y2]), % cases toutes les deux remplies
	gameOver([X1, Y1], [9,9]), % Une case sur deux remplie
	gameOver([9, 9], [X2,Y2]), % Une case sur deux remplie 
	gameOver([1, 0], [9,9]), % Une case dehors
	gameOver([9,9], [11,10]),
	gameOver([0,2], [X2,Y2]). % Une case dehors

	 