% TODO : Prendre en compte le choix du deuxième joueur à retirer des candidats du joueur au deuxième choix n3

% IA minimax qui essaye d'enfermer son adversaire en faisant en sorte d'arriver avant lui à un point donné 
% l'IA se base sur un arbre des prévisions à 3 niveaux où chaque niveau contient les choix possibles des 
% joueurs aux prochains tours
% Niveau 1: IA(max), Niveau 2: Adversaire(min), Niveau 3: IA(max).



distance(X,Y,D) :- D is X-Y, D>=0.
distance(X,Y,D) :- D is Y-X, D>=0.

% calcule le cout d'une feuille 
leafValue(XP1,YP1,XP2,YP2,X,Y,Value) :- distance(XP1,X,DX1), distance(YP1,Y,DY1), Val1 is DX1+DY1,
										distance(XP2,X,DX2), distance(YP2,Y,DY2), Val2 is DX2+DY2,
										Val is Val2-Val1,
										Value is 10-Val .

% Pour un ensemble de points vide, il n'y a pas de noeuds fils
setChildrenNodes(X, Y, [], []).

% construit une liste des noeuds fils d'un noeud à partir d'un ensemble de numéros de cases 
setChildrenNodes(X, Y, Children, [H|R]) :- move(H,X,Y,NewX,NewY), Ch1 = [	[ [NewX,NewY,_],_ ]	],  
													setChildrenNodes(X, Y, Ch2, R), union(Ch1, Ch2, Children).

% Crée le niveau 1 de l'arbre
levelOneTree(Board,XP1,YP1,XP2,YP2,[[XP1,YP1,_],Children]) :- 
							% Associe au premier noeud (Position actuelle de P1) la liste de ses noeuds fils	
							whichSet2(Board,XP1,YP1,Set), setChildrenNodes(XP1, YP1, Children, Set), 
							% Ajoute les niveaux 2 et 3						
							levelTree(Board,Children,XP2,YP2).

% Permet d'ajouter le niveau 2 et 3 
% Le niveau 2 correspend aux cases candidates pour l'adversaires 
% Le niveau 3 correspend aux cases candidates pour l'IA après un premier tour joué 
% (Dépendent de la case du premier niveau)
levelTree(Board,[],_,_).
levelTree(Board,[ [ [X,Y,_] , Children ] | R ],XP2,YP2) :- 	whichSet2(Board,XP2,YP2,SetL2),
															setChildrenNodes(XP2, YP2, Children, SetL2), 
															whichSet2(Board,X,Y,Set), setChildrenNodes(X, Y, ChildrenNextLevel, Set),
															levelThreeTree(Board,Children,ChildrenNextLevel),
															levelTree(Board,R,XP2,YP2).

levelThreeTree(Board,[], _) .														
levelThreeTree(Board,[ [ [X,Y,_] , Children ] | R ], Children) :-  	levelThreeTree(Board,R, Children).


% Affiche les feuilles de l'arbre
displayLeaves([ [X,Y,C],[] ]) :- writeln(X+" : "+Y+" : "+C).
displayLeaves([ [X,Y,C], Ch ]) :- displayElt(Ch).

displayElt([]).
displayElt([H|R]) :- displayLeaves(H), displayElt(R).

% Trouver le coup le plus avantageux à jouer (entre -10 et 10)

% Prend le max des couts des noeuds de niveau 1, 
%(Bx,By) : la case ayant le cout max
grade([  _, [ [ [X,Y,_],Ch ] | R ] ], Bx, By, Grade, 1) :- 	grade([ [X,Y,_],Ch ],X,Y,GradeC1,2),
															grade([ [X,Y,C], R ],Bx1,By1,GradeC2,1), 
															max_member(Grade,[GradeC1,GradeC2]),
															( 	
																(Grade is GradeC2, Bx is Bx1, By is By1);
																(Grade is GradeC1, Bx is X, By is Y)
															) .   
% Si pas de niveau 1 le cout est minimal (-10)
grade([ [X,Y,C], [] ] ,X,Y,-10,1).

% Prend le min des couts des noeuds de niveau 2 
% (Xd,Yd) : le noeud père
grade([  _, [ [ [X,Y,_],Ch ] | R ] ] ,Xd,Yd,Grade,2) :- 	grade([ [X,Y,_],Ch ],Xd,Yd,X,Y,GradeC1,3),
															grade([ _,R ],Xd,Yd,GradeC2,2), 
															min_member(Grade,[GradeC1,GradeC2]) .
% Si pas de niveau 2 le cout est maximal (10)
grade([ _, [] ] ,_,_,10,2).

% Prend le max des noeuds de niveau 3 
% (Xd1,Yd1) : Le noeud grand-père
% (Xd2,Yd2) : Le noeud père
grade([ _, [ [ [X,Y,_],Ch ] | R ] ] ,Xd1,Yd1,Xd2,Yd2,Grade,3) :- 	leafValue(Xd1,Yd1,Xd2,Yd2,X,Y,GradeC1),
																	grade([ _, R ],Xd1,Yd1,Xd2,Yd2,GradeC2,3), 
																	max_member(Grade,[GradeC1,GradeC2]) .
% Le cout retourné est 0 
grade([ _, [] ] ,_,_,_,_,-10,3).

% Retourne le deplacement au cout le plus favorable d'après l'arbre !
iaMiniMax(Board, [M1,M2],[XP1,YP1]) :- board(_,_,[XP2,YP2]),levelOneTree(Board,XP1,YP1,XP2,YP2,Tree), grade(Tree,M1,M2,Grade,1). 