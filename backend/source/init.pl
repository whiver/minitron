%Init pourrav pour tester
init :- assert(dim(10)),
	dim(D), N is D*D, %Calcul des dimensions
	X1 is 1, Y1 is 1, X2 is 10, Y2 is 10, %définition des points des 2 têtes
	matrice(X1, Y1, Board, 1), matrice(X2, Y2, Board, 2), %Placement des têtes dans la matrice
	initList(Board, N), %initialisation du reste de la matrice avec des 0
	assert(board(Board, [X1, Y1], [X2, Y2])), %assertion du fait board
	displayBoard. %Affichage (Remplacer plus tard par le lancement du jeu)

% Initialisation 2
% Ne mettre que les têtes représentatnt les deux joueurs
initList(List, Size) :- length(List,Size). 
