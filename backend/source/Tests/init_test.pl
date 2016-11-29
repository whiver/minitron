test_start :-
	start(10, [1, 1], [10, 10], 'AI_FOLLOWER', 'AI_RANDOM2'),
	dim(10),
	board(Board, [1, 1], [10, 10]),
	initList(Board, 100),
	playerAI(1, 'AI_FOLLOWER'),
	playerAI(2, 'AI_RANDOM2').
