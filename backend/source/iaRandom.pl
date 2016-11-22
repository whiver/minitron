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

% IA calculant le prochain déplacement 
nextMove(X,Y,NewX,NewY) :- random_member(N,[0,1,2,3]), move(N,X,Y,NewX,NewY).
ia(Board, [M1,M2],[P1,P2]) :- dim(N),nextMove(P1,P2,M1,M2).
