% Applique les 2 coups sur une nouvelle board (NewBoard)
% arg1 -> Ancienne board
% arg2 -> Nouvelles coordonnées de la tête du joueur 1
% arg3 -> Nouvelles coordonnées de la tête du joueur 2
% arg4 -> Nouvelle board
playMoves(Board, [X1,Y1], [X2,Y2], NewBoard) :- Board = NewBoard, matrice(X1, Y1, NewBoard, 1), matrice(X2, Y2, NewBoard, 2).

% Supprime l'ancienne board et les anciennes têtes, instancie la nouvelle board
% arg1 -> Ancienne board
% arg2 -> Ancienne tete joueur 1
% arg3 -> Ancienne tete joueur 2
% arg1 -> Nouvelle board
% arg2 -> Nouvelle tete joueur 1
% arg3 -> Nouvelle tete joueur 2
applyIt(Board, Head1, Head2, NewBoard, NewHead1, NewHead2) :- retract(board(Board, Head1, Head2)), assert(board(NewBoard, NewHead1, NewHead2)).


% On arrive à la fin du jeu dès que l'un des joueurs essaye de sortir du plateau, ou dès qu'il marche sur ça trainé ou celle de
% l'autre joueur

out(X,Y,N) :- X>N; Y>N; X<1; Y<1.

% Les deux mouvements sont Out
winner(Board,[X1,Y1], [X2,Y2],'DRAW') :-  dim(N), out(X1,Y1,N), out(X2,Y2,N). 
% Le 1 est Out, le 2 est à bon.
winner(Board,[X1,Y1], [X2,Y2],'WINNER2') :-  dim(N), out(X1,Y1,N), not(out(X2,Y2,N)), matrice(X2,Y2,Board,N2), var(N2).
% Le 2 est Out, le 1 n'est bon.
winner(Board,[X1,Y1], [X2,Y2],'WINNER1') :-  dim(N), out(X2,Y2,N), not(out(X1,Y1,N)), matrice(X1,Y1,Board,N1), var(N1).
% Le 2 est Out, le 1 est dedans mais a percuté 1 ou 2
winner(Board,[X1,Y1], [X2,Y2],'DRAW') :-  dim(N), out(X2,Y2,N), not(out(X1,Y1,N)), matrice(X1,Y1,Board,N1), nonvar(N1).
% Le 1 est Out, le 2 est dedans mais a percuté 1 ou 2
winner(Board,[X1,Y1], [X2,Y2],'DRAW') :-  dim(N), out(X1,Y1,N), not(out(X2,Y2,N)), matrice(X2,Y2,Board,N2), nonvar(N2).
% Les deux sont dedans, et veulent la même case
winner(Board,[X,Y], [X,Y],'DRAW').
% Les deux sont dedans, les deux ont percuté 1 ou 2 
winner(Board,[X1,Y1], [X2,Y2],'DRAW') :- matrice(X1,Y1,Board,N1), nonvar(N1),matrice(X2,Y2,Board,N2), nonvar(N2).
% 2 a percuté, et pas 1
winner(Board,[X1,Y1], [X2,Y2],'WINNER1') :- matrice(X2,Y2,Board,N2), nonvar(N2), matrice(X1,Y1,Board,N1), var(N1).
% 1 a percuté, et pas 2
winner(Board,[X1,Y1], [X2,Y2],'WINNER2') :- matrice(X1,Y1,Board,N1), nonvar(N1), matrice(X2,Y2,Board,N2), var(N2).

% Le match doit continuer car aucun joueur n'a perdu
winner(Board, [X1,Y1], [X2,Y2], 'CONTINUE') :-
    dim(N),
    not(out(X1, Y1, N)), not(out(X2, Y2, N)),
    matrice(X1, Y1, Board, N1), var(N1),
    matrice(X2, Y2, Board, N2), var(N2).

is1or2([]).
is1or2([T|Q]) :- nonvar(T),(T=1; T=2), is1or2(Q).

gameOver(Board, W) :- is1or2(Board), W = 'DRAW'.
gameOver(Move1,Move2, W) :- board(Board,_,_),winner(Board,Move1,Move2,W).

playNext(State, TimeStep) :-
    State = 'CONTINUE',
    sleep(TimeStep),
    playAuto(TimeStep).

playNext('DRAW', _) :-
    writeln('The game ends with a draw!').

playNext('WINNER1', _) :-
    writeln('Player 1 wins the game!').

playNext('WINNER2', _) :-
    writeln('Player 2 wins the game!').

playNext(State, _) :-
    format('State:~w', [State]).

playAuto(TimeStep) :-
    writeln('\33\[2J'),
    board(Board, H1, H2),
    playerAI(1, P1AI),
    ai(P1AI, Board, Move1, H1), !,
    playerAI(2, P2AI),
    ai(P2AI, Board, Move2, H2), !,
    checkPlay(Move1, Move2, State),
    displayBoard,
    playNext(State, TimeStep).

ai('AI_FOLLOWER', Board, Move, Head) :- iaFollower(Board, Move, Head).
ai('AI_RANDOM2', Board, Move, Head) :- iaRandom2(Board, Move, Head).

applyPlay(Move1, Move2) :-
    board(Board, H1, H2),
    playMoves(Board, Move1, Move2, NewBoard),
    applyIt(Board, H1, H2, NewBoard, Move1, Move2).

checkPlay(Move1, Move2, State) :-
    State = 'CONTINUE',
    gameOver(Move1, Move2, State),
    applyPlay(Move1, Move2).

checkPlay(Move1, Move2, State) :-
    gameOver(Move1, Move2, State).

playOnce(State) :-
    board(Board, H1, H2),
    playerAI(1, P1AI),
    ai(P1AI, Board, Move1, H1), !,
    playerAI(2, P2AI),
    ai(P2AI, Board, Move2, H2), !,
    checkPlay(Move1, Move2, State).
