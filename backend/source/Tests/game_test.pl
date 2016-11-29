test_game :-
	test_out,
	test_game_over.

% Teste les cas où un point se trouve à l'intérieur ou en dehors des dimensions d'un plateau
test_out :-
	not(out(3,5,10)),
	not(out(10,10,10)),
	not(out(1,1,10)),
	out(0,5,10), 
	out(6,0,10),
	out(11,2,10),
	out(3,12,10),
	out(0,0,10),
	out(12,11,10).

% Teste toutes les issues possibles selon la position des deux joueurs
test_game_over :-
	% Ici les IA n'ont pas d'importance
	start(10, [5, 5], [8, 8], 'AI_RANDOM2', 'AI_FOLLOWER'),
	% Cases libres => la partie doit continuer
	gameOver([6, 6], [9, 9], S1), S1 = 'CONTINUE',
	% Cases toutes deux occupées => match nul
	gameOver([5, 5], [8, 8], S2), S2 = 'DRAW',
	% Le joueur 1 est sur un emplacement occupé, mais pas le joeur 2 => joueur 2 l'emporte
	gameOver([5, 5], [9, 9], S3), S3 = 'WINNER2',
	% Le joueur 2 est sur un emplacement occupé, mais pas le joeur 1 => joueur 1 l'emporte
	gameOver([6, 6], [8, 8], S4), S4 = 'WINNER1',
	% Le joueur 1 sort des limites du plateau; le joueur 2 est sur un emplacement libre => joueur 2 l'emporte
	gameOver([1, 0], [9, 9], S5), S5 = 'WINNER2',
	% Le joueur 2 sort des limites du plateau; le joueur 1 est sur un emplacement libre => joueur 1 l'emporte
	gameOver([2, 2], [11, 10], S6), S6 = 'WINNER1',
	% Le joueur 1 sort des limites du plateau; le joueur 2 est sur un emplacement occupé => match nul
	gameOver([1, 0], [8, 8], S7), S7 = 'DRAW',
	% Le joueur 2 sort des limites du plateau; le joueur 1 est sur un emplacement occupé => match nul
	gameOver([5, 5], [11, 10], S8), S8 = 'DRAW'.
	 