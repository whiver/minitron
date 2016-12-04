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


% Vérifie que la case est en hors du plateau (Une case du mur)
out(X,Y,N) :- X>N; Y>N; X<1; Y<1.

% Vérifie si un des cas de game over se présente et détermine le gagnant

% Les deux mouvements sont Out
winner(_,[X1,Y1], [X2,Y2],'DRAW') :-  dim(N), out(X1,Y1,N), out(X2,Y2,N). 
% Le 1 est Out, le 2 est bon.
winner(Board,[X1,Y1], [X2,Y2],'WINNER2') :-  dim(N), out(X1,Y1,N), not(out(X2,Y2,N)), matrice(X2,Y2,Board,N2), var(N2).
% Le 2 est Out, le 1 n'est pas bon.
winner(Board,[X1,Y1], [X2,Y2],'WINNER1') :-  dim(N), out(X2,Y2,N), not(out(X1,Y1,N)), matrice(X1,Y1,Board,N1), var(N1).
% Le 2 est Out, le 1 est dedans mais a percuté 1 ou 2
winner(Board,[X1,Y1], [X2,Y2],'DRAW') :-  dim(N), out(X2,Y2,N), not(out(X1,Y1,N)), matrice(X1,Y1,Board,N1), nonvar(N1).
% Le 1 est Out, le 2 est dedans mais a percuté 1 ou 2
winner(Board,[X1,Y1], [X2,Y2],'DRAW') :-  dim(N), out(X1,Y1,N), not(out(X2,Y2,N)), matrice(X2,Y2,Board,N2), nonvar(N2).
% Les deux sont dedans, et veulent la même case
winner(_,[X,Y], [X,Y],'DRAW').
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

% Détermine l'état du jeu si les deux coups sont joués
% Move1 -> Coup du joueur 1
% Move2 -> Coup du joueur 2
% W -> Étqt du jeu si les deux coups sont joués
gameOver(Move1,Move2, W) :- board(Board,_,_), winner(Board,Move1,Move2,W).

% Appelle une nouvelle itération de jeu si la partie doit continuer (pas de perdant)
% State -> État de la partie
% TimeStep -> Intervale de temps en secondes avant la prochaine itération
playNext(State, TimeStep) :-
    State = 'CONTINUE',
    sleep(TimeStep),
    playAuto(TimeStep).

% Affiche le match nul
playNext('DRAW', _) :-
    writeln('The game ends with a draw!').

% Affiche la victoire du joueur 1
playNext('WINNER1', _) :-
    writeln('Player 1 wins the game!').

% Affiche la victoire du joueur 2
playNext('WINNER2', _) :-
    writeln('Player 2 wins the game!').

% Joue automatiquement la partie dans la console, en enchaînant les itérations suivant un intervale de temps
% TimeStep -> Intervale de temps en secondes entre chaque itération de jeu
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

% Demande un coup à l'IA "Follower" à partir d'une position du joueur.
% Board -> Plateau de jeu
% Move -> Coup que va jouer l'IA
% Head -> Position courante de la tête du joueur
ai('AI_FOLLOWER', Board, Move, Head) :- iaFollower(Board, Move, Head).

% Demande un coup à l'IA "Random2" à partir d'une position du joueur.
% Board -> Plateau de jeu
% Move -> Coup que va jouer l'IA
% Head -> Position courante de la tête du joueur
ai('AI_RANDOM2', Board, Move, Head) :- iaRandom2(Board, Move, Head).

% Demande un coup à l'IA "Minimax" à partir d'une position du joueur.
% Board -> Plateau de jeu
% Move -> Coup que va jouer l'IA
% Head -> Position courante de la tête du joueur
ai('AI_MINIMAX', Board, Move, Head) :- iaMiniMax(Board, Move, Head).

% Applique les coups au plateau
% Move1 -> Coup du joueur 1
% Move2 -> Coup du joueur 2
applyPlay(Move1, Move2) :-
    board(Board, H1, H2),
    playMoves(Board, Move1, Move2, NewBoard),
    applyIt(Board, H1, H2, NewBoard, Move1, Move2).

% Vérifie le résultat des coups et n'applique ces coups que si ce résultat est 'CONTINUE'
% Move1 -> Coup du joueur 1
% Move2 -> Coup du joueur 2
% State -> État résultant des coups à jouer
checkPlay(Move1, Move2, State) :-
    State = 'CONTINUE',
    gameOver(Move1, Move2, State),
    applyPlay(Move1, Move2).

% Vérifie le résultat des coups et donne l'état correspondant.
% Move1 -> Coup du joueur 1
% Move2 -> Coup du joueur 2
% State -> État résultat des coups à jouer
checkPlay(Move1, Move2, State) :-
    gameOver(Move1, Move2, State).

% Joue une itération du jeu et retourne l'état résultant
% State -> État résultant de l'itération (vals : 'CONTINUE', 'DRAW', 'WINNER1', 'WINNER2').
playOnce(State) :-
    board(Board, H1, H2),
    playerAI(1, P1AI),
    ai(P1AI, Board, Move1, H1), !,
    playerAI(2, P2AI),
    ai(P2AI, Board, Move2, H2), !,
    checkPlay(Move1, Move2, State).
