% iaMiniMax
% L'IA utilise un arbre à 3 niveau
% Niveau 1 : Les cases à jouer par l'IA
% Niveau 2 : Les cases à jouer par l'adversaire en enlevant la case jouée par l'IA (Cas à éviter)
% Niveau 3 : Les cases à jouer par l'IA au prochain tour en évitant la case jouée son adversaire

% Elle peux Eviter d'aller dans une case qui causera sa perte au prochain tour
% Elle suit son adversaire et donc le bloque en crayant un mur devant lui
% Il arrive qu'en suivant son adversaire l'IA se renferme elle même 

distance(X,Y,D) :- D is X-Y, D>=0.
distance(X,Y,D) :- D is Y-X, D>=0.
distanceCells([X1,Y1], [X2,Y2], Val) :- distance(X1,X2,DX), distance(Y1,Y2,DY), Val is DX+DY.

% Inverse des coordonnées
inv(Num,X,Y) :- dim(N), R is Num mod N, Q is div(Num,N), ((R > 0, X is Q+1, Y is R); (X is Q, Y is N)).

% Calcule le nombre de cases les plus proches de chaque joueur 
amountArea([],_,_,_,_,A1, A2, A1, A2,_).
amountArea([H|Rest],XP1,YP1,XP2,YP2,A1, A2, NewA1, NewA2, Pos) :- 	nonvar(H),
																	NextPos is Pos + 1,
																	amountArea(Rest,XP1,YP1,XP2,YP2,A1,A2,NewA1,NewA2,NextPos).

amountArea([H|Rest],XP1,YP1,XP2,YP2,A1, A2, NewA1, NewA2,Pos) :- 	var(H),
																	inv(Pos,X,Y),
																	distanceCells([XP1,YP1], [X,Y], Val1),
																	distanceCells([XP2,YP2], [X,Y], Val2),
																	((Val1 < Val2, R1 is A1+1, R2 is A2);
																	(Val1 > Val2, R1 is A1, R2 is A2+1);
																	(Val1 = Val2, R1 is A1, R2 is A2)),	
																	NextPos is Pos + 1,															
																	amountArea(Rest,XP1,YP1,XP2,YP2,R1,R2,NewA1,NewA2,NextPos).

% calcule le cout d'une feuille 
% choisit le point le plus proche de l'adversaire
% [XP2,YP2] : Nouvelles coordonnées du joueur 2 (Niveau 2 de l'arbre)
% [X,Y] : Nouvelles coordonnées du joueur 1 au prochain tour (Niveau 3 de l'arbre)
leafValue(_,_,XP2,YP2,X,Y,Value,"PROCHE") :-	distance(XP2,X,DX2), distance(YP2,Y,DY2), Value is -(DX2+DY2).

% calcule le cout d'une feuille 
% choisit le point le plus loin de l'adversaire
% [XP2,YP2] : Nouvelles coordonnées du joueur 2 (Niveau 2 de l'arbre)
% [X,Y] : Nouvelles coordonnées du joueur 1 au prochain tour (Niveau 3 de l'arbre)
leafValue(_,_,XP2,YP2,X,Y,Value,"LOIN") :-	distance(XP2,X,DX2), distance(YP2,Y,DY2), Value is DX2+DY2.

% L'ia choisit le point qui fait qu'elle a le plus de cases proches d'elle 
leafValue(_,_,XP2,YP2,X,Y,Value,"CASES") :- board(Board,_,_),amountArea(Board,X,Y,XP2,YP2,0, 0, NewA1, NewA2,1),
									Value is (NewA1-NewA2).
% Pour un ensemble de points vides, il n'y a pas de noeuds fils
setChildrenNodes(_, _, [], []).

% construit une liste des noeuds fils d'un noeud à partir d'un ensemble de numéros de cases 
% [H|R] : Ensemble de numéros de cases
% Children : Liste de noeuds représentant ces cases
setChildrenNodes(X, Y, Children, [H|R]) :- move(H,X,Y,NewX,NewY), Ch1 = [	[ [NewX,NewY],_ ]	],  
													setChildrenNodes(X, Y, Ch2, R), union(Ch1, Ch2, Children).

% Crée le niveau 1 de l'arbre
% Si plus de cases à jouer (La liste des Children est vide)
% [XP1, YP1] : Position de l'IA
% [XP2, YP2] : Position de son adversaire
% En dernier paramètre : La tête de l'arbre
levelOneTree(Board,XP1,YP1,XP2,YP2,[[XP1,YP1],Children]) :- 
							% Associe au premier noeud (Position actuelle de P1) la liste de ses noeuds fils	
							whichSet2(Board,XP1,YP1,Set), setChildrenNodes(XP1, YP1, Children, Set), 
							% Ajoute les niveaux 2 et 3						
							levelTree(Board,Children,XP2,YP2).

% Permet d'ajouter les niveaux 2 et 3 de l'arbre
% Ne fait rien pour une liste vide de Children (Aucun noeud de niveau 1)
levelTree(_,[],_,_).
% Pour chaque noeud de niveau 1, ajoute les noeuds des niveaux 2 et 3
% (si un noeud est au niveau 1 il est enlevé des noeuds du niveau 2)
levelTree(Board,[ [ [X,Y] , Children ] | R ],XP2,YP2) :- 	whichSet2(Board,XP2,YP2,SetL2),
															% Enlever le noeud choisi au niveau 1 
															% des cases candidates du joueur 2
															% Branche à évite
															((move(NL1,XP2,YP2,X,Y), S = [NL1]); S = []),
															subtract(SetL2,S, SetL2ToUse),
															setChildrenNodes(XP2, YP2, Children, SetL2ToUse), 
															% Ajouter les noeuds du niveau 3											
															levelThreeTree(Board, Children, X, Y),
															% Passer au prochain noeud de niveau 1
															levelTree(Board,R,XP2,YP2).
% Ajoute les noeuds de niveau 3
% Ne fait rien si la liste des noeuds du niveau 2 est vide
levelThreeTree(_,[], _,_) .			
% Ajoute la liste des noeuds de niveau 3 à chaque noeud de la liste de noeuds de niveau 2
% [Xl1,Yl1] : Position du noeud de niveau 1 de la branche actuelle 
% Noeud père du noeud (X,Y)											
levelThreeTree(Board,[ [ [X,Y] , Children ] | R ], Xl1,Yl1) :-  	% Enlever le noeud choisi par le joueur adverse
																	% des cases candidates
																	whichSet2(Board,Xl1,Yl1,Set),
																	((move(NL1,Xl1,Yl1,X,Y), S = [NL1]); S = []),
																	subtract(Set,S, SetToUse),
																	setChildrenNodes(Xl1, Yl1, Children, SetToUse),
																	levelThreeTree(Board,R, Xl1, Yl1).


% Affiche les feuilles de l'arbre
displayLeaves([ [X,Y],[] ]) :- writeln(X+" : "+Y).
displayLeaves([ [_,_], Ch ]) :- displayElt(Ch).
displayElt([]).
displayElt([H|R]) :- displayLeaves(H), displayElt(R).

% Trouve le coup le plus avantageux à jouer (entre -10 et 10)
% Prend le max des couts des noeuds de niveau 1, 
%(Bx,By) : la case ayant le cout max
grade([  _, [ [ [X,Y],Ch ] | R ] ], Bx, By, Grade, 1,Type) :- 	grade([ [X,Y],Ch ],X,Y,GradeC1,2,Type),
															grade([ [X,Y], R ],Bx1,By1,GradeC2,1,Type), 
															max_member(Grade,[GradeC1,GradeC2]),
															( 	
																(Grade is GradeC2, Bx is Bx1, By is By1);
																(Grade is GradeC1, Bx is X, By is Y)
															) .   
% Si pas/plus de noeuds de niveau 1 le cout est minimal 
% Retourne la case elle même comme meilleure case 
grade([ [X,Y], [] ] ,X,Y,ValMin,1,"CASES") :- dim(N), ValMin is -N*N .
grade([ [X,Y], [] ] ,X,Y,ValMin,1,Type) :- dim(N), ValMin is -N*2 .

% Prend le min des couts des noeuds de niveau 2 
% (Xd,Yd) : le noeud père du noeud de niveau 2
grade([  _, [ [ [X,Y],Ch ] | R ] ] ,Xd,Yd,Grade,2,Type) :- 	grade([ [X,Y],Ch ],Xd,Yd,X,Y,GradeC1,3,Type),
															grade([ _,R ],Xd,Yd,GradeC2,2,Type), 
															min_member(Grade,[GradeC1,GradeC2]) .
% Si pas/plus de noeuds de niveau 2 le cout est maximal
grade([ _, [] ] ,_,_,ValMax,2,"CASES") :- dim(N), ValMax is N*N .
grade([ _, [] ] ,_,_,ValMax,2,_) :- dim(N), ValMax is N*2 .

% Prend le max des noeuds de niveau 3 
% (Xd1,Yd1) : Le noeud grand-père du noeud de niveau 3
% (Xd2,Yd2) : Le noeud père du noeud de niveau 3
grade([ _, [ [ [X,Y],_ ] | R ] ] ,Xd1,Yd1,Xd2,Yd2,Grade,3,Type) :- 	leafValue(Xd1,Yd1,Xd2,Yd2,X,Y,GradeC1,Type),
																	grade([ _, R ],Xd1,Yd1,Xd2,Yd2,GradeC2,3,Type), 
																	max_member(Grade,[GradeC1,GradeC2]) .
% Si pas/plus de noeuds de niveau 3 le cout est minimal 
grade([ _, [] ] ,_,_,_,_,ValMin,3,"CASES") :- dim(N), ValMin is -N*N .
grade([ _, [] ] ,_,_,_,_,ValMin,3,Type) :- dim(N), ValMin is -N*2 .


% Retourne le deplacement au cout le plus favorable d'après l'arbre !
% Si même le niveau 1 est abscent dans l'arbre 
% L'IA n'a plus aucune case à jouer 
% M1, M2 correspend à XP1, XP2 (Ce qui déclanche le game over)
iaMiniMax(Board, [M1,M2],[XP1,YP1]) :- 	board(_,_,[XP2,YP2]),levelOneTree(Board,XP1,YP1,XP2,YP2,Tree),
										grade(Tree,M1,M2,_,1,"PROCHE").
iaMiniMaxF(Board, [M1,M2],[XP1,YP1]) :- 	board(_,_,[XP2,YP2]),levelOneTree(Board,XP1,YP1,XP2,YP2,Tree),
										grade(Tree,M1,M2,_,1,"LOIN").
iaMiniMaxC(Board, [M1,M2],[XP1,YP1]) :- 	board(_,_,[XP2,YP2]),levelOneTree(Board,XP1,YP1,XP2,YP2,Tree),
										grade(Tree,M1,M2,_,1,"CASES").

