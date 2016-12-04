test_iaMiniMax :- 	clean,
					init_iaMiniMax,
					setChildrenNodes_test,
					levelOneTree_test,
					leafValue_test,
					grade_test .

% Crée un environement pour le test
init_iaMiniMax :- 	assert(dim(10)),		
					% Remplit des cases par des 1 ou des 2 
					% Pour dire qu'elles appartiennent au joueur1 ou 2 
			    	matrice(1, 10, Board, 1),matrice(10, 1, Board, 2),matrice(4, 3, Board, 1),
			    	matrice(1, 2, Board, 2),matrice(2, 2, Board, 2),matrice(3, 2, Board, 2),
					matrice(2, 1, Board, 2),matrice(2, 3, Board, 2),matrice(3, 4, Board, 2),
					% Initialisation de Board
				    initList(Board, 100),
				    assert(board(Board, [1, 10], [10, 1])).


setChildrenNodes_test :- 	setChildrenNodes(2, 2, [], []),				% Aucun élément dans l'ensemble fourni
							setChildrenNodes(3, 1, Children1, [2]),		% Un seul élément dans l'ensemble fourni
							nonvar(Children1),
							Children1 = [
								[
									[4,1],_
								]
							],
							setChildrenNodes(1, 10, Children2, [2,3]), 	% Deux éléments dans l'ensemble fourni
							nonvar(Children2),
							Children2 = [
								[
									[2,10],_
								],
								[
									[1,9],_
								]
							],
							setChildrenNodes(2, 3, Children3, [0,1,2]),	% Trois éléments dans l'ensemble fourni
							nonvar(Children3),
							Children3 = [
								[
									[1,3],_
								],
								[
									[2,4],_
								],
								[
									[3,3],_
								]
							],
							setChildrenNodes(3, 4, Children4, [0,1,2,3]), % Quatre éléments dans l'ensemble fourni
							nonvar(Children4),
							Children4 = [
								[
									[2,4],_
								],
								[
									[3,5],_
								],
								[
									[4,4],_
								],
								[
									[3,3],_
								]
							] .

levelOneTree_test :- 	board(Board,_,_),
						levelOneTree(Board,1,10,10,1,Tree), % Arbre décrivant l'état du jeux en 3 niveaux
						Tree = [

									[1,10],[
												[ 
													[2,10],[
														[
															[9,1],[
																[
																	[3,10],[]
																],
																[
																	[2,9],[]
																]
															]
														],
														[
															[10,2],[
																[
																	[3,10],[]
																],
																[
																	[2,9],[]
																]
															]
														]
													] 
												],

												[ 
													[1,9],[
														[
															[9,1],[
																[
																	[2,9],[]
																],
																[
																	[1,8],[]
																]
															]
														],
														[
															[10,2],[
																[
																	[2,9],[]
																],
																[
																	[1,8],[]
																]
															]
														]
													] 
												]
											]

								].

leafValue_test :- 	leafValue(2,10,9,1,3,10,Value),
					Value is -4.

grade_test :- 	Tree0 = [[1,10],[]], 				% Pas de niveau 1
				Tree1 = [ [1,10],[
							[[2,10],[]]				% Pas de niveau 2
						]],
				Tree2 = [ [1,10],[					% Pas de niveau 3
							[[2,10],[
								[[9,1],[]]
							]]
						]],
				Tree3 = 							% 2 ème branche moins favorable (l'ia perd au prochain tour)
						[ [1,10],[
							[[2,10],[
								[[9,1],[
									[[3,10],[]]
								]]
							]],
							[[1,9],[
								[[9,1],[]]
							]]
						]],
				% (l'adversaire perd au prochain tour)
				% Dans le cas ou les deux vont sur la même case et que 
				% c'est la dernière de l'adversaire!! (A améliorer)
				
				grade(Tree0, Bx0, By0, Grade0, 1),
				Grade0 is -10 , Bx0 is 1, By0 is 10,
				grade(Tree1, Bx1, By1, Grade1, 1),
				Grade1 is 10 , Bx1 is 2, By1 is 10,
				grade(Tree2, Bx2, By2, Grade2, 1),
				Grade2 is -10 , Bx2 is 2, By2 is 10,
				grade(Tree3, Bx3, By3, Grade3, 1),
				Grade3 is -4 , Bx3 is 2, By3 is 10.
				
