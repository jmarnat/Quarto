equi_piece(0,[0,0,0,0]). %% Differents Caracteristics of every Piece
equi_piece(1,[0,0,0,0]).
equi_piece(2,[0,0,0,1]).
equi_piece(3,[0,0,1,0]).
equi_piece(4,[0,0,1,1]).
equi_piece(5,[0,1,0,0]).
equi_piece(6,[0,1,0,1]).
equi_piece(7,[0,1,1,0]).
equi_piece(8,[0,1,1,1]).
equi_piece(9,[1,0,0,0]).
equi_piece(10,[1,0,0,1]).
equi_piece(11,[1,0,1,0]).
equi_piece(12,[1,0,1,1]).
equi_piece(13,[1,1,0,0]).
equi_piece(14,[1,1,0,1]).
equi_piece(15,[1,1,1,0]).
equi_piece(16,[1,1,1,1]).


askPiece_jeremie(inline,Board,PieceID_adv) :- %% Give a Piece to the opponent
	%% printAvailablePieces(Board), %% Display all the available pieces
	return_piece_adv(Board,PieceID_adv), %% Give the chosen piece
	write(PieceID_adv),nl,
	retractall(link_game(_,_)), %% Delete all the Knowledge
	retractall(weight_board(_,_,_,_,_)), %% Delete all the Knowledge
	isAvailable(Board,PieceID_adv).
	
readPosition_jeremie(inline,Board,PieceID,Row,Col) :- %% If we are the first one to play we place randomly our Piece
	getAvailablePieces(Board,AvailablePieces),
	length(AvailablePieces,Length),
	Length >= 15,
	createArbre(Board,PieceID,1,1,Lvl1),
	getAvailablePieces(Board,ListOfPieces),
	delete(ListOfPieces,PieceID,NewListOfPieces),
	createArbreLvl2_board(Lvl1,NewListOfPieces,_),
	random_between(1,4,Col),
	random_between(1,4,Row),
	isEmpty(Board,Row,Col).

readPosition_jeremie(inline,Board,PieceID,Row,Col) :-	%% We are looking for the best placement for our piece
	createArbre(Board,PieceID,1,1,Lvl1), %% We are creating the first level of our tree (All the possibility to where to put our piece)
	getAvailablePieces(Board,ListOfPieces),
	delete(ListOfPieces,PieceID,NewListOfPieces),
	createArbreLvl2_board(Lvl1,NewListOfPieces,_), %% With the remaining pieces we are creating the second level of ou tree with all the possibility to play for our opponent
	return_place(Board,Row,Col), %% We are looking for the best placement for our Piece
	Row > 0, Row < 5,
	Col > 0, Col < 5,
	isEmpty(Board,Row,Col).
	
%% These following functions are creating all "Son Board" with a given piece and a given Board
%% At the end we will have a List with all the Boards generated
	
createArbre(Board,PieceID,4,4,[NewBoardJouable]) :-
	isEmpty(Board,4,4),	
	putPieceOnBoard(PieceID,4,4,Board,NewBoardJouable),
	calcul_weight_board(NewBoardJouable,ListWeightNewBoardJouable), %% We are calculating the weight of the new Board
	asserta(link_game(Board,NewBoardJouable)), %% We are creating all the links to allow us to go through the tree later
	asserta(weight_board(NewBoardJouable,ListWeightNewBoardJouable,4,4,PieceID)). %% We are creating all the links to allow us to go through the tree later
	%% Fournis Liste pieces available
	
createArbre(Board,PieceID,4,Col,ListNewBoard):-	
	Col < 4,
	isEmpty(Board,4,Col),
	putPieceOnBoard(PieceID,4,Col,Board,NewBoardJouable),
		calcul_weight_board(NewBoardJouable,ListWeightNewBoardJouable),
	asserta(link_game(Board,NewBoardJouable)),
	asserta(weight_board(NewBoardJouable,ListWeightNewBoardJouable,4,Col,PieceID)),
	Col2 is Col + 1,
	createArbre(Board,PieceID,1,Col2,ListNewBoardNext),
	append([NewBoardJouable],ListNewBoardNext,ListNewBoard).


createArbre(Board,PieceID,Row,Col,ListNewBoard):-
	Row < 4,
	Col < 4,
	isEmpty(Board,Row,Col),	
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoardJouable),
		calcul_weight_board(NewBoardJouable,ListWeightNewBoardJouable),
	asserta(link_game(Board,NewBoardJouable)),
	asserta(weight_board(NewBoardJouable,ListWeightNewBoardJouable,Row,Col,PieceID)),
	Row2 is Row + 1,
	createArbre(Board,PieceID,Row2,Col,ListNewBoardNext),
	append([NewBoardJouable],ListNewBoardNext,ListNewBoard).
	
createArbre(Board,PieceID,Row,4,ListNewBoard):-
	Row < 4,
	isEmpty(Board,Row,Col),	
	putPieceOnBoard(PieceID,Row,4,Board,NewBoardJouable),
		calcul_weight_board(NewBoardJouable,ListWeightNewBoardJouable),
	asserta(link_game(Board,NewBoardJouable)),
	asserta(weight_board(NewBoardJouable,ListWeightNewBoardJouable,Row,Col,PieceID)),
	Row2 is Row + 1,
	createArbre(Board,PieceID,Row2,4,ListNewBoardNext),
	append([NewBoardJouable],ListNewBoardNext,ListNewBoard).
	
createArbre(Board,PieceID,Row,4,_):-
	Row < 4,
	isFull(Board,Row,4),	
	Row2 is Row + 1,
	createArbre(Board,PieceID,Row2,4,_).

	
createArbre(Board,PieceID,Row,Col,ListNewBoardNext):-
	Row < 4,
	Col < 4,
	Row2 is Row + 1,
	createArbre(Board,PieceID,Row2,Col,ListNewBoardNext).

createArbre(Board,_,4,4,[]) :-
	isFull(Board,4,4), !.

createArbre(Board,PieceID,4,Col,ListNewBoardNext):-
	Col < 4,
	isFull(Board,4,Col),
	Col2 is Col + 1,
	createArbre(Board,PieceID,1,Col2,ListNewBoardNext).

%% Here we are creating all the Board possible given a given list of Boards and of Piece
%% These functions are calling CreateArbre/5, to generate the second level of the tree, to manage the move of the opponent.
	
createArbreLvl2_board([],[_ | _],[]).
	
createArbreLvl2_board([SelectedBoard|OtherBoards],[FirstAvailablePiece | Tail],ListNewBoard):-
	createArbreLvl2([SelectedBoard], [FirstAvailablePiece | Tail],PossibleMoves),
	createArbreLvl2_board(OtherBoards,[FirstAvailablePiece | Tail],PossibleMovesNext),
	
	append([PossibleMoves],PossibleMovesNext,ListNewBoard).

createArbreLvl2(_,[],[]).

createArbreLvl2([SelectedBoard|_],[FirstAvailablePiece | Tail],ListNewBoard):-
	createArbre(SelectedBoard, FirstAvailablePiece,1,1,PossibleMoves),
	createArbreLvl2([SelectedBoard],Tail,PossibleMovesNext),
	append([PossibleMoves],PossibleMovesNext,ListNewBoard).
	
%% We are calculating the weight of every given board	
	
calcul_weight_board(Board,ListOfWeights):- %% This function give a list with all the differents weights of the board
	calcul_weight_Lines(Board,TotalWeightLines), %% Give the weight of every lines
	calcul_weight_col(Board,TotalWeightCol), %% Give the weight of every Columns
	calcul_weight_Diag(Board,TotalWeightDiag), %% Give the weight of every Diagonals
	append(TotalWeightCol,TotalWeightDiag,Tmp_weight), 
	append(TotalWeightLines,Tmp_weight,ListOfWeights).
	
calcul_weight_Lines_pieces([E1,E2,E3,E4 | _],[W1,W2,W3,W4]):- %% Give the weight of a Line
	equi_piece(E1,[E11,E12,E13,E14]),
	equi_piece(E2,[E21,E22,E23,E24]),
	equi_piece(E3,[E31,E32,E33,E34]),
	equi_piece(E4,[E41,E42,E43,E44]),
	W1 is E11+E21+E31+E41,
	W2 is E12+E22+E32+E42,
	W3 is E13+E23+E33+E43,
	W4 is E14+E24+E34+E44.
	
calcul_weight_Lines([],[]). %% Give the weight of every Lines of a given Board
	
calcul_weight_Lines([[E1,E2,E3,E4]|Tail],TotalWeightLines):-
	calcul_weight_Lines_pieces([E1,E2,E3,E4],TotalWeightLinesPiecesNow),
	calcul_weight_Lines(Tail,TotalWeightLinesPiecesNext),
	append([TotalWeightLinesPiecesNow],TotalWeightLinesPiecesNext,TotalWeightLines).
	
	
%% Give the weight of every Columns of a given Board	
calcul_weight_col([[E11,E21,E31,E41],[E12,E22,E32,E42],[E13,E23,E33,E43],[E14,E24,E34,E44]|[]],[[Col1_1,Col1_2,Col1_3,Col1_4],[Col2_1,Col2_2,Col2_3,Col2_4],[Col3_1,Col3_2,Col3_3,Col3_4],[Col4_1,Col4_2,Col4_3,Col4_4] |[]]):-
	equi_piece(E11,[E11_1,E11_2,E11_3,E11_4]),
	equi_piece(E21,[E21_1,E21_2,E21_3,E21_4]),
	equi_piece(E31,[E31_1,E31_2,E31_3,E31_4]),
	equi_piece(E41,[E41_1,E41_2,E41_3,E41_4]),
	%% 2nd Line
	equi_piece(E12,[E12_1,E12_2,E12_3,E12_4]),
	equi_piece(E22,[E22_1,E22_2,E22_3,E22_4]),
	equi_piece(E32,[E32_1,E32_2,E32_3,E32_4]),
	equi_piece(E42,[E42_1,E42_2,E42_3,E42_4]),
	%% 3rd Line
	equi_piece(E13,[E13_1,E13_2,E13_3,E13_4]),
	equi_piece(E23,[E23_1,E23_2,E23_3,E23_4]),
	equi_piece(E33,[E33_1,E33_2,E33_3,E33_4]),
	equi_piece(E43,[E43_1,E43_2,E43_3,E43_4]),
	%% 4th Line
	equi_piece(E14,[E14_1,E14_2,E14_3,E14_4]),
	equi_piece(E24,[E24_1,E24_2,E24_3,E24_4]),
	equi_piece(E34,[E34_1,E34_2,E34_3,E34_4]),
	equi_piece(E44,[E44_1,E44_2,E44_3,E44_4]),
	%% Calcul Weight Col1
	Col1_1 is E11_1+E12_1+E13_1+E14_1,
	Col1_2 is E11_2+E12_2+E13_2+E14_2,
	Col1_3 is E11_3+E12_3+E13_3+E14_3,
	Col1_4 is E11_4+E12_4+E13_4+E14_4,
	%% Calcul Weight Col2
	Col2_1 is E21_1+E22_1+E23_1+E24_1,
	Col2_2 is E21_2+E22_2+E23_2+E24_2,
	Col2_3 is E21_3+E22_3+E23_3+E24_3,
	Col2_4 is E21_4+E22_4+E23_4+E24_4,
	%% Calcul Weight Col3
	Col3_1 is E31_1+E32_1+E33_1+E34_1,
	Col3_2 is E31_2+E32_2+E33_2+E34_2,
	Col3_3 is E31_3+E32_3+E33_3+E34_3,
	Col3_4 is E31_4+E32_4+E33_4+E34_4,
	%% Calcul Weight Col4
	Col4_1 is E41_1+E42_1+E43_1+E44_1,
	Col4_2 is E41_2+E42_2+E43_2+E44_2,
	Col4_3 is E41_3+E42_3+E43_3+E44_3,
	Col4_4 is E41_4+E42_4+E43_4+E44_4.
	
	
%% Give the weight of every Diagonals of a given Board	
calcul_weight_Diag([[E11,_,_,E41],[_,E22,E32,_],[_,E23,E33,_],[E14,_,_,E44]|[]],[[Wdiag1_1,Wdiag1_2,Wdiag1_3,Wdiag1_4],[Wdiag2_1,Wdiag2_2,Wdiag2_3,Wdiag2_4]|[]]):-
	equi_piece(E11,[E11_1,E11_2,E11_3,E11_4]),
	equi_piece(E22,[E22_1,E22_2,E22_3,E22_4]),
	equi_piece(E33,[E33_1,E33_2,E33_3,E33_4]),
	equi_piece(E44,[E44_1,E44_2,E44_3,E44_4]),
	Wdiag1_1 is E11_1+E22_1+E33_1+E44_1,
	Wdiag1_2 is E11_2+E22_2+E33_2+E44_2,
	Wdiag1_3 is E11_3+E22_3+E33_3+E44_3,
	Wdiag1_4 is E11_4+E22_4+E33_4+E44_4,
	equi_piece(E14,[E14_1,E14_2,E14_3,E14_4]),
	equi_piece(E23,[E23_1,E23_2,E23_3,E23_4]),
	equi_piece(E32,[E32_1,E32_2,E32_3,E32_4]),
	equi_piece(E41,[E41_1,E41_2,E41_3,E41_4]),
	Wdiag2_1 is E41_1+E32_1+E23_1+E14_1,
	Wdiag2_2 is E41_2+E32_2+E23_2+E14_2,
	Wdiag2_3 is E41_3+E32_3+E23_3+E14_3,
	Wdiag2_4 is E41_4+E32_4+E23_4+E14_4.
	

%% Return the max value of a List
my_max([], R, R).
my_max([X|Xs], WK, R):- X >  WK, my_max(Xs, X, R).
my_max([X|Xs], WK, R):- X =< WK, my_max(Xs, WK, R).
my_max([X|Xs], R):- my_max(Xs, X, R).

%% Return the min value of a List
my_min([], R, R).
my_min([X|Xs], WK, R):- X <  WK, my_min(Xs, X, R).
my_min([X|Xs], WK, R):- X >= WK, my_min(Xs, WK, R).
my_min([X|Xs], R):- my_min(Xs, X, R).

%% Return a value as far as possible of 2
near_2([],R,R).
near_2([El|Tail],El1,R):- El/2 =< El1/2, near_2(Tail,El1,R).
near_2([El|Tail],El1,R):- El/2 > El1/2, near_2(Tail,El,R).
near_2([El1|Tail],R):- near_2(Tail,El1,R).

%% If we are the first one to play we give a random piece
return_piece_adv(Board,PieceID_adv):-
	getAvailablePieces(Board,AvailablePieces),
	length(AvailablePieces,Length),
	Length >= 16,
	randomPiece(PieceID_adv,AvailablePieces).

%% Give the Piece to give to the opponent	
return_piece_adv(Board,PieceID_adv):-
	findall(NewBoard,link_game(Board,NewBoard),ListFils),
	poids_Board_piece_adv_fct(ListFils,ListMin),
	near_2(ListMin,Near2),
	poids_Board_piece(_,_,_,Near2,PieceID_adv).

poids_Board_piece_adv_fct([],[]). %% Give the List of Weight of every possibilities

poids_Board_piece_adv_fct(List1,[WeightBoard|ListMinPrec]):-
	member(Board_fa,List1),
	poids_Board_piece(Board_fa,_,_,WeightBoard,_),
	delete(List1,Board_fa,List2),
	poids_Board_piece_adv_fct(List2,ListMinPrec).

return_place(Board,Row,Col):- %% Give the Row and the Col to optimize the placement of our given Piece
	findall(NewBoard,link_game(Board,NewBoard),ListFils),
	poids_Board_piece_fct(ListFils,ListMin),
	my_min(ListMin,MinWeight),
	poids_Board_place(_,Row,Col,MinWeight,_ ).
	
poids_Board_piece_fct([],[]). %% Give the List of Weight of every possibilities
	
poids_Board_piece_fct(List1,[WeightBoard|ListMinPrec]):-
	member(Board_fa,List1),
	poids_Board_place(Board_fa,_,_,WeightBoard,_),
	delete(List1,Board_fa,List2),
	poids_Board_piece_fct(List2,ListMinPrec).
	
poids_Board_place(Board,Row,Col,WeightBoard,PieceID):- %% Give the weight of a board for the placement
	weight_board(Board,[L1,L2,L3,L4,Col1,Col2,Col3,Col4,Diag1,Diag2],Row,Col,PieceID),
	my_max(L1,MaxL1),
	my_max(L2,MaxL2),
	my_max(L3,MaxL3),
	my_max(L4,MaxL4),
	my_max(Col1,MaxCol1),
	my_max(Col2,MaxCol2),
	my_max(Col3,MaxCol3),
	my_max(Col4,MaxCol4),
	my_max(Diag1,MaxDiag1),
	my_max(Diag2,MaxDiag2),
	ListMax = [MaxL1,MaxL2,MaxL3,MaxL4,MaxCol1,MaxCol2,MaxCol3,MaxCol4,MaxDiag1,MaxDiag2],
	my_min(L1,MinL1),
	my_min(L2,MinL2),
	my_min(L3,MinL3),
	my_min(L4,MinL4),
	my_min(Col1,MinCol1),
	my_min(Col2,MinCol2),
	my_min(Col3,MinCol3),
	my_min(Col4,MinCol4),
	my_min(Diag1,MinDiag1),
	my_min(Diag2,MinDiag2),
	ListMin = [MinL1,MinL2,MinL3,MinL4,MinCol1,MinCol2,MinCol3,MinCol4,MinDiag1,MinDiag2],
	my_max(ListMax,ElemMax),
	my_min(ListMin,ElemMin),
	TestMax is 4-ElemMax,
	TestMin is 0+ElemMin,
	ListWeightPlace = [TestMax,TestMin],
	my_min(ListWeightPlace,WeightBoard).

	
poids_Board_piece(Board,Row,Col,ElemMax,PieceID):- %% %% Give the weight of a board in order to pick the worst piece for the opponent
	weight_board(Board,[L1,L2,L3,L4,Col1,Col2,Col3,Col4,Diag1,Diag2],Row,Col,PieceID),
	my_max(L1,MaxL1),
	my_max(L2,MaxL2),
	my_max(L3,MaxL3),
	my_max(L4,MaxL4),
	my_max(Col1,MaxCol1),
	my_max(Col2,MaxCol2),
	my_max(Col3,MaxCol3),
	my_max(Col4,MaxCol4),
	my_max(Diag1,MaxDiag1),
	my_max(Diag2,MaxDiag2),
	ListMax = [MaxL1,MaxL2,MaxL3,MaxL4,MaxCol1,MaxCol2,MaxCol3,MaxCol4,MaxDiag1,MaxDiag2],
	my_max(ListMax,ElemMax).
	
	
	%% Boucle Infini / Amélioration IA (3eme row ?!) + Gestion si victoire prochain coup.
	
	

























