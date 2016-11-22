% IA triviale
% avec par ex. 1 : tourner à gauche
%			   2 : aller tout droit
%			   3 : tourner à droite
iaRandom(Low, High, Resultat) :-  random_between(Low, High, Resultat).

%Echoue ou reussi selon que la position soit occupee ou non.
positionValide(X, Y) :- board(Board,_,_), matrice(X,Y,Board, Element) , var(Element).




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
