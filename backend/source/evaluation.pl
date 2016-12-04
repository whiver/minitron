% Condition d'arrêt
eval(_, _, _, 0, [0,0]) :- true.

% Eval - Evalue 2 IA sur un certain nombre de NbParties
% BoardSize -> la taille de la board
% P1AI -> IA du joueur 1
% P2AI -> IA du joueur 2
% NbParties -> nombre de parties à lancer
% [P1, P2] -> P1 nombre de victoires J1, P2 nombre de victoires J2
eval(BoardSize,
     P1AI,
     P2AI,
     NbParties,
     [P1, P2]) :-
	Restant is NbParties - 1, eval(BoardSize, P1AI, P2AI, Restant, [P1Temp, P2Temp]),
	Middle is BoardSize / 2,
	random_between(1, Middle,  P1X),
	random_between(Middle, BoardSize, P2X),
	random_between(1, BoardSize,  P1Y),
	random_between(1, BoardSize, P2Y),
	start(BoardSize, [P1X, P1Y], [P2X, P2Y], P1AI, P2AI),
	playAuto(0, false, R),
	((R is 1, P1 is P1Temp + 1, P2 is P2Temp) ; (R is 2, P2 is P2Temp + 1, P1 is P1Temp) ; (R is 0, P1 is P1Temp, P2 is P2Temp)).