%%% MiniTron %%%

:- dynamic board/3, dim/1. % permet l'assertion et le retrait de faits board/3 (Board + les 2 têtes)

%On ne prendra que des matrice carrees
 


%Pour recuperer un element d une liste vue comme une matrice
extraire(X,Y,R) :- dim(D), R is ((X*D)+Y).
% TODO : ATTENTION : ici X est associe à "X-1", et Y à "Y-1" pour des appels plus "naturels", à discuter
matrice(X,Y,List, Element) :- extraire((X-1),(Y-1),R), nth0( R, List, Element, _).

%Initialise une liste avec N valeurs V (Besoin de refactor ?)
initList(_, [], 0).
initList(V, [H | Tail], N) :- (H is V; H is 1; H is 2), Prec is N-1, initList(V, Tail, Prec).

% Initialisation 2
% Ne mettre que les têtes représentatnt les deux joueurs
initList(List, Size) :- length(List,Size). 

% Applique les 2 coups sur une nouvelle board (NewBoard)
% Move1 -> Nouvelles coordonnées de la tête du joueur 1
% Move2 -> Nouvelles coordonnées de la tête di joueur 2
% Completement daubée ! TODO : Trouver un moyen de copier Board dans NewBoard, sauf pour les 2 nouveaux points.
playMoves(Board, [X1,Y1], [X2,Y2], NewBoard) :- Board = NewBoard, matrice(X1, Y1, NewBoard, 1), matrice(X2, Y2, NewBoard, 2).

% Supprime l'ancienne board et les anciennes têtes, instancie la nouvelle board
applyIt(Board, Head1, Head2, NewBoard, NewHead1, NewHead2) :- retract(board(Board, Head1, Head2)), assert(board(NewBoard, NewHead1, NewHead2)).

%Affiche toute la board
displayBoard :- board(Board, _, _), displayElem(Board, 0).

%Affiche un élément et lance l’affichage de l'élément suivant
displayElem([], _).
displayElem([H|T], I) :- dim(D), I is D-1, ((nonvar(H), writeln(H)); writeln(0)), displayElem(T, 0).
displayElem([H|T], I) :- ((nonvar(H), write(H)); write(0)), succ(I, Next), displayElem(T, Next).


% IA triviale
% avec par ex. 1 : tourner à gauche
%			   2 : aller tout droit
%			   3 : tourner à droite
iaRandom(Low, High, Resultat) :-  random_between(Low, High, Resultat).

%Echoue ou reussi selon que la position soit occupee ou non.
positionValide(X, Y) :- board(Board,_,_), matrice(X,Y,Board, Element) , Element == 0.




%Attention, C EST FOIREUX, methode peut etre pas bonne.
checkHaut(X, Y, Xsol, Ysol) :- Xsol is (X-1), Ysol is (Y), positionValide(Xsol, Ysol).
checkBas(X, Y, Xsol, Ysol) :- Xsol is (X+1), Ysol is (Y), positionValide(Xsol, Ysol).


% Les deplacement possibles à l'intérieur
move(0,X,Y,NewX,NewY) :- NewX is X-1, NewY is Y.
move(1,X,Y,NewX,NewY) :- NewX is X, NewY is Y+1.
move(2,X,Y,NewX,NewY) :- NewX is X+1, NewY is Y.
move(3,X,Y,NewX,NewY) :- NewX is X, NewY is Y-1.

% se placer sur la board 
whereInBoard(X,Y,N,[0,1,2,3]) :-  X \== N, Y \== N, X \== 1, Y \== 1 .
whereInBoard(1,1,_,[1,2]).
whereInBoard(1,Y,N,[1,2,3]) :- Y \== 1, Y \== N.
whereInBoard(1,N,N,[2,3]).
whereInBoard(X,N,N,[0,2,3]) :- X \== 1, X \== N.
whereInBoard(N,N,N,[0,3]).
whereInBoard(N,Y,N,[0,1,3]) :-  Y \== 1, Y \== N.
whereInBoard(N,1,N,[0,1]) .
whereInBoard(X,1,N,[0,1,2]) :- X \== 1, X \== N.

% IA calculant le prochain déplacement 
nextMove(X,Y,NewX,NewY,Size) :-  whereInBoard(X,Y,Size,Possibilities),random_member(N,Possibilities), move(N,X,Y,NewX,NewY).
ia(Board, [M1,M2],[P1,P2]) :- dim(N),nextMove(P1,P2,M1,M2,N).

is1or2([]).
is1or2([T|Q]) :- nonvar(T),(T=1; T=2), is1or2(Q).

gameOver :- board(Board,_,_),is1or2(Board).

play :- gameOver.
play :- writeln('New turn'),
    		board(Board, Head1, Head2), % instanciate the board from the knowledge base 
       		displayBoard, % print it
           	ia(Board, Move1,Head1), % ask the AI for a move, that is, an index for the Player 
    	    ia(Board, Move2,Head2),
    		playMoves(Board, Move1, Move2, NewBoard), % Play the move and get the result in a new Board
    		applyIt(Board, Head1, Head2, NewBoard, Move1, Move2), % Remove the old board from the KB and store the new one
			sleep(0.5),
			play.

%Init pourrav pour tester
init :- assert(dim(10)),
	dim(D), N is D*D, %Calcul des dimensions
	X1 is 1, Y1 is 1, X2 is 10, Y2 is 10, %définition des points des 2 têtes
	matrice(X1, Y1, Board, 1), matrice(X2, Y2, Board, 2), %Placement des têtes dans la matrice
	initList(Board, N), %initialisation du reste de la matrice avec des 0
	assert(board(Board, [X1, Y1], [X2, Y2])), %assertion du fait board
	displayBoard, %Affichage (Remplacer plus tard par le lancement du jeu)
	play.

% Serveur HTTP capable de traiter les requêtes de l'IHM %
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

server(Port) :-
        http_server(http_dispatch,
                    [ port(Port) ]).

:- http_handler(root(boardState), httpBoardState, []).

% Convertit le board en JSON
boardToJSON :-
	board(Board, H1, H2),
	format('"board":[', []),
	boardElemToJSON(Board), 
	format(']', []),
	format(',"heads":[', []),
	headToJSON(H1),
	format(',', []),
	headToJSON(H2),
	format(']', []).

% Convertit un élément du board en JSON et convertit le suivant
boardElemToJSON([]).
boardElemToJSON([H|T]) :- format('~w,', [H]), boardElemToJSON(T).

headToJSON([H|[T|_]]) :- format('{"x":~w,"y":~w}', [H, T]).

httpBoardState(_) :-
	format('Content-type: application/json~n~n', []),
	format('{', []),
	boardToJSON,
	format('}', []).
