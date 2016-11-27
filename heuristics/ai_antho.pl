%% This AI is base on a strategy made by Anthony

invertAttribute(white,black).
invertAttribute(black,white).
invertAttribute(short,long).
invertAttribute(long,short).
invertAttribute(round,square).
invertAttribute(square,round).
invertAttribute(hole,flat).
invertAttribute(flat,hole).

printRC(R,C):-write('['),write(R),write(','),write(C),write(']'),nl.
printAPiece(PieceID):-
write(PieceID),write(' ('),printPiece(PieceID),write(')'),nl.

countPieces(16,[]):-!.
countPieces(Nu,[H|T]):-
	countEmpty(NE,H),	
	countPieces(N,T),
	Nu is N-NE.
countEmpty(NE,[0|T]):-
	countEmpty(NET,T),
	NE is NET+1.
countEmpty(NE,[_|T]):-
	countEmpty(NE,T).
countEmpty(0,[]).

invertPiece(PieceID,InvertID):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IVColor),
	invertAttribute(Height,IVHeight),
	invertAttribute(Geometry,IVGeometry),
	invertAttribute(Hole,IVHole),
	piece(InvertID,[IVColor,IVHeight,IVGeometry,IVHole]).
share3(PieceID,[P1,P2,P3,P4]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IVColor),
	invertAttribute(Height,IVHeight),
	invertAttribute(Geometry,IVGeometry),
	invertAttribute(Hole,IVHole),
	piece(P1,[Color,Height,Geometry,IVHole]),
	piece(P2,[Color,Height,IVGeometry,Hole]),
	piece(P3,[Color,IVHeight,Geometry,Hole]),
	piece(P4,[IVColor,Height,Geometry,Hole]).
share1(PieceID,[P1,P2,P3,P4]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IVColor),
	invertAttribute(Height,IVHeight),
	invertAttribute(Geometry,IVGeometry),
	invertAttribute(Hole,IVHole),
	piece(P1,[IVColor,IVHeight,IVGeometry,Hole]),
	piece(P2,[IVColor,IVHeight,Geometry,IVHole]),
	piece(P3,[IVColor,Height,IVGeometry,IVHole]),
	piece(P4,[Color,IVHeight,IVGeometry,IVHole]).
share2(PieceID,[P1,P2,P3,P4,P5,P6]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IVColor),
	invertAttribute(Height,IVHeight),
	invertAttribute(Geometry,IVGeometry),
	invertAttribute(Hole,IVHole),
	piece(P1,[Color,Height,IVGeometry,IVHole]),
	piece(P2,[Color,IVHeight,Geometry,IVHole]),
	piece(P3,[Color,IVHeight,IVGeometry,Hole]),
	piece(P4,[IVColor,Height,Geometry,IVHole]),
	piece(P5,[IVColor,Height,IVGeometry,Hole]),
	piece(P6,[IVColor,IVHeight,Geometry,Hole]).

getNonLoosesPieces(Board,PiecesList):-
	getLoosesPieces(Board,LoosePieces),
	getAvailablePieces(Board,PossiblePieces),
	subtract(PossiblePieces,LoosePieces,PiecesList),!
.
getLoosesPieces(Board,ListOfPieces):-
	getAvailablePieces(Board,AvailablePieces),
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).

getLoosesPiecesBis(_,[],[]).
getLoosesPiecesBis(Board,[PieceID|ListOfPieces],[PieceID|AvailablePieces]) :-
	checkWinPosition(Board,PieceID,_,_),
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).
getLoosesPiecesBis(Board,ListOfPieces,[_|AvailablePieces]) :-
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).
checkWinPosition(Board,PieceID,Row,Col):-
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	check_win(NewBoard,_,_,_),!.

printGameState(Board):-
	getNonLoosesPieces(Board,NLP),
	printRC('NonLoosesPieces',NLP),
	getLoosesPieces(Board,LP),
	printRC('LoosesPieces',LP),
	getAvailablePieces(Board,AP),
	printRC('AvailablePieces',AP)
.










/*Choosing Piece To give */
choosePiece(_,N,MyPieceID,PieceID,PiecesList,LoosePieces):-
	givePiece(N,MyPieceID,PieceID,PiecesList,LoosePieces)
.
choosePiece(Board,_,_,PieceID,_,_):-
	getAvailablePieces(Board,AvailablePieces),
	write('random choose:'), nl,
	randomPiece(PieceID,AvailablePieces).

askPiece_ai_antho(inline,Board,PieceID,MyPieceID):-
	countPieces(N,Board),
	printAvailablePieces(Board),
	getLoosesPieces(Board,LoosePieces),
	write('LoosePieces:'),write(LoosePieces),nl,
	getAvailablePieces(Board,PossiblePieces),
	write('PossiblePieces:'),write(PossiblePieces),nl,
	subtract(PossiblePieces,LoosePieces,PiecesList),
	write('PiecesList:'),write(PiecesList),nl,
	choosePiece(Board,N,MyPieceID,PieceID,PiecesList,LoosePieces),
	write('I choose :'),printAPiece(PieceID).

givePiece(0,_,PieceID,AvailablePieces,_):-
	randomPiece(PieceID,AvailablePieces)
.
givePiece(N,MyPieceID,PieceID,AvailablePieces,LoosePieces):-
	findPiece(N,MyPieceID,PieceID),
	checkPiece(PieceID,AvailablePieces,LoosePieces).
givePiece(_,_,PieceID,AvailablePieces,LoosePieces):-
	randomPiece(PieceID,AvailablePieces),
	\+memberchk(PieceID,LoosePieces)
.

checkPiece(PieceID,AvailablePieces,LoosePieces):-
	memberchk(PieceID,AvailablePieces),
	\+memberchk(PieceID,LoosePieces).

findPiece(N,MyPieceID,PieceID):-
	N>0,N<5,
	invertPiece(MyPieceID,PieceID).
findPiece(N,MyPieceID,PieceID):-
	N>0,N<5,
	share1(MyPieceID,PiecesList),
	memberchk(PieceID,PiecesList).
findPiece(N,MyPieceID,PieceID):-
	N>0,N<5,
	share2(MyPieceID,PiecesList),
	memberchk(PieceID,PiecesList).
findPiece(N,MyPieceID,PieceID):-
	N>4,
	share3(MyPieceID,PiecesList),
	%% write(' Share 3 : '),write(PiecesList),nl,
	memberchk(PieceID,PiecesList).
findPiece(N,MyPieceID,PieceID):-
	N>4,
	share2(MyPieceID,PiecesList),
	%% write(' Share 2 : '),write(PiecesList),nl,
	memberchk(PieceID,PiecesList).
findPiece(N,MyPieceID,PieceID):-
	N>4,
	share1(MyPieceID,PiecesList),
	%% write(' Share 1 : '),write(PiecesList),nl,
	memberchk(PieceID,PiecesList).
randomPiece(RandomPiece,AvailablePieces):-
	random_member(RandomPiece,AvailablePieces).

	/* Choosing better Place For my Piece */












%% Searching for a wining position
readPosition_ai_antho(inline,Board,PieceID,Row,Col):-
	checkWinPosition(Board,PieceID,Row,Col).

readPosition_ai_antho(inline,Board,PieceID,Row,Col):-
	choosePosition(Board,PieceID,Row,Col)
	.


goodMove(_,0,_,_).
goodMove(Board,PieceID,Row,Col):-
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	getAvailablePieces(NewBoard,AP),
	\+getLoosesPieces(NewBoard,AP)
	.
emptyList([]).
choosePosition(Board,PieceID,Row,Col):-
	printAPiece(PieceID),
	countPieces(N,Board),
	findPosition(N,Board,PieceID,Row,Col).


/*trouvez une position sans aligenement 0-5*/
findPosition(N,Board,_,Row,Col):-
	N<5,N>0,write('find X<5'),nl,
	optimalPos(4,Board,0,Row,Col)
.

findPosition(N,Board,PieceID,Row,Col):-
	N>5,
	write('find Defense'),nl,
	getLoosesPieces(Board,[]),
	getNonLoosesPieces(Board,NLP),
	NLP == [PieceID],
	findDefensePosition(Board,PieceID,Row,Col)
.
findPosition(N,Board,PieceID,Row,Col):-
	N>5,write('find 2'),nl,
	optimalPos(2,Board,PieceID,Row,Col)
.
findPosition(N,Board,PieceID,Row,Col):-
	N>5,write('find 1'),nl,
	optimalPos(1,Board,PieceID,Row,Col)
.
findPosition(N,Board,PieceID,Row,Col):-
	N>5,write('find 0'),nl,
	optimalPos(0,Board,PieceID,Row,Col)
.
findPosition(_,Board,_,Row,Col):-
	isEmpty(Board,Row,Col),
	random_member(Row,[2,3,1,4]),
	random_member(Col,[2,3,1,4])
.
findDefensePosition(Board,PieceID,Row,Col):-
	write('try Defensive'),nl,
	getLoosesPieces(Board,LoosePieces),
	random_member(AvailablePiece,LoosePieces),
	checkWinPosition(Board,AvailablePiece,Row,Col),
	goodMove(Board,PieceID,Row,Col)
.
%% Defensive

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(N,N,N,Board,PieceID,Row,Col).

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(N,_,_,Board,PieceID,Row,Col).

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(_,N,_,Board,PieceID,Row,Col).

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(_,_,N,Board,PieceID,Row,Col).


optimalPos(N1,N2,N3,Board,PieceID,Row,Col):-
	piece(PieceID,Attributes),
	memberchk(RAttribute,Attributes),
	selectListPiece(Row,Board,SelectedRow),
	searchNAttribute(N1,SelectedRow,RAttribute),
	memberchk(CAttribute,Attributes),
	boardRowToCol(Board,ColBoard),
	selectListPiece(Col,ColBoard,SelectedCol),
	searchNAttribute(N2,SelectedCol,CAttribute),

	checkDiag(N3,Board,Row,Col,Attributes),
	goodMove(Board,PieceID,Row,Col)
	.
checkDiag(N1,Board,Row,Col,Attributes):-
	memberchk(DAttribute,Attributes),
	boardDiagonal(Board,BoardDiagonal),
	random_member(DiagPos,[3,1,4,2]),
	selectListPiece(Diag,BoardDiagonal,SelectedDia),
	searchNAttribute(N1,SelectedDia,DAttribute),
	diagRowCol(Diag,DiagPos,Row,Col)
.
checkDiag(_,_,Row,Col,_):-
	\+diagRowCol(_,_,Row,Col).
searchNAttribute(N,[],_):-
	N is 0.
searchNAttribute(N,[0|RestOfPieces],nul):-
	searchNAttribute(Nr,RestOfPieces,nul),
	N is Nr+1.
searchNAttribute(N,[PieceID|RestOfPieces],Attribute):-
	searchAttribute(PieceID,Attribute),
	searchNAttribute(Nr,RestOfPieces,Attribute),
	N is Nr+1
	.

searchNAttribute(N,[_|RestOfPieces],Attribute):-
	searchNAttribute(N,RestOfPieces,Attribute).
searchAttribute(PieceID,Attribute):-
	piece(PieceID,Attributes),
	memberchk(Attribute,Attributes).

selectListPiece(1,[X|_],X).
selectListPiece(2,[_|[X|_]],X).
selectListPiece(3,[_,_,X,_],X).
selectListPiece(4,[_,_,_,X],X).
diagRowCol(1,DiagPos,DiagPos,DiagPos).
diagRowCol(2,DiagPos,DiagPos,DiagPos2):-
	DiagPos2 is 5-DiagPos.
boardDiagonal([[W1,_,_,Z1],[_,X2,Y2,_],[_,X3,Y3,_],[W4,_,_,Z4]],[[W1,X2,Y3,Z4],[W4,X3,Y2,Z1]]).

boardRowToCol([[W1,X1,Y1,Z1],[W2,X2,Y2,Z2],[W3,X3,Y3,Z3],[W4,X4,Y4,Z4]],[[W1,W2,W3,W4],[X1,X2,X3,X4],[Y1,Y2,Y3,Y4],[Z1,Z2,Z3,Z4]]).