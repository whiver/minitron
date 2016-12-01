test_iaMiniMax :- 	clean,
					init_iaMiniMax,
					setChildrenNodes_test,
					levelOneTree_test,
					leafValue_test,
					displayLeaves_test,
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
									[4,1,_],_
								]
							],
							setChildrenNodes(1, 10, Children2, [2,3]),
							nonvar(Children2),
							Children2 = [
								[
									[2,10,_],_
								],
								[
									[1,9,_],_
								]
							],
							setChildrenNodes(2, 3, Children3, [0,1,2]),
							nonvar(Children3),
							Children3 = [
								[
									[1,3,_],_
								],
								[
									[2,4,_],_
								],
								[
									[3,3,_],_
								]
							],
							setChildrenNodes(3, 4, Children4, [0,1,2,3]),
							nonvar(Children4),
							Children4 = [
								[
									[2,4,_],_
								],
								[
									[3,5,_],_
								],
								[
									[4,4,_],_
								],
								[
									[3,3,_],_
								]
							] .

levelOneTree_test :- 	board(Board,_,_),
						levelOneTree(Board,1,10,10,1,Tree),
						Tree = [

									[1,10,_],[
												[ 
													[2,10,_],[
														[
															[9,1,_],[
																[
																	[3,10,_],[]
																],
																[
																	[2,9,_],[]
																]
															]
														],
														[
															[10,2,_],[
																[
																	[3,10,_],[]
																],
																[
																	[2,9,_],[]
																]
															]
														]
													] 
												],

												[ 
													[1,9,_],[
														[
															[9,1,_],[
																[
																	[2,9,_],[]
																],
																[
																	[1,8,_],[]
																]
															]
														],
														[
															[10,2,_],[
																[
																	[2,9,_],[]
																],
																[
																	[1,8,_],[]
																]
															]
														]
													] 
												]
											]

								],displayLeaves(Tree).

leafValue_test :- 	leafValue(2,10,9,1,3,10,Value),
					Value is -4.

displayLeaves_test :- displayLeaves([ 
										[10,2,_], [
													[[1,2,4],[
														[[3,6,_],[]]
													]],
										[[3,3,_],[]]
									] ]).

grade_test :- 	Tree = 	
						[ [1,10,_],[
							[[2,10,_],[
								[[9,1,_],[
									[[3,10,_],[]]
								]]
							]]
						]],
					
				displayLeaves(Tree),
				grade(Tree, Bx, By, Grade, 1),
				Grade is -4 , Bx is 2, By is 10,
				board(Board,_,_),
				levelOneTree(Board,1,10,10,1,Tree2),
				grade(Tree2, Bx2, By2, Grade2, 1).
