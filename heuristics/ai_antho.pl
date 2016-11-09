%% This AI is base on a strategy made by Anthony

invertAttribute(white,black).
invertAttribute(black,white).
invertAttribute(short,long).
invertAttribute(long,short).
invertAttribute(round,square).
invertAttribute(square,round).
invertAttribute(hole,flat).
invertAttribute(flat,hole).


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

getLoosesPieces(Board,ListOfPieces) :-
	getAvailablePieces(Board,AvailablePieces),
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).

getLoosesPiecesBis(_,[],[]).
getLoosesPiecesBis(Board,[PieceID|ListOfPieces],[PieceID|AvailablePieces]) :-
	checkWinPosition(Board,PieceID,_,_),
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).
getLoosesPiecesBis(Board,ListOfPieces,[_|AvailablePieces]) :-
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).
checkWinPosition(Board,PieceID,Row,Col):-
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	check_win(NewBoard,_,_,_).

/*Choosing Piece To give */
askPiece_ai_antho(inline,Board,PieceID,MyPieceID):-
	printAvailablePieces(Board),
	countPieces(N,Board),
	getAvailablePieces(Board,PossiblePieces),
	getLoosesPieces(Board,LoosePieces),
	subtract(PossiblePieces,LoosePieces,PiecesList),
	write('AvailablePieces:'),write(PossiblePieces),nl,
	write('loosePieces:'),write(LoosePieces),nl,
	write('subtract:'),write(PiecesList),nl,
	givePiece(N,MyPieceID,PieceID,PiecesList,LoosePieces),
	write('I choose :'),write(PieceID),nl,nl,printPiece(PieceID),nl,nl.

givePiece(0,_,PieceID,AvailablePieces,_):-
	findPiece(0,_,PieceID,AvailablePieces)
.
givePiece(N,MyPieceID,PieceID,AvailablePieces,LoosePieces):-
	findPiece(N,MyPieceID,PieceID),
	checkPiece(PieceID,AvailablePieces,LoosePieces).
givePiece(N,MyPieceID,PieceID,AvailablePieces,_):-
	findPiece(N,MyPieceID,PieceID,AvailablePieces).

message(0).
message(_):-write('Probably Loose').
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
	N>4,
	share3(MyPieceID,PiecesList),
	write(' Share 3 : '),write(PiecesList),nl,
	memberchk(PieceID,PiecesList).
findPiece(N,MyPieceID,PieceID):-
	N>4,
	share2(MyPieceID,PiecesList),
	write(' Share  2 : '),write(PiecesList),nl,
	memberchk(PieceID,PiecesList).
findPiece(N,MyPieceID,PieceID):-
	N>4,
	share1(MyPieceID,PiecesList),
	write(' Share 1 : '),write(PiecesList),nl,
	memberchk(PieceID,PiecesList).
findPiece(_,_,RandomPiece,AvailablePieces):-
	random_member(RandomPiece,AvailablePieces).

	/* Choosing better Place For my Piece */


readPosition_ai_antho(inline,Board,PieceID,Row,Col):-
	choosePosition(Board,PieceID,Row,Col).
readPosition_ai_antho(inline,Board,PieceID,Row,Col):-
	readPosition_random(inline,Board,PieceID,Row,Col).

%% Searching for a wining position
choosePosition(Board,PieceID,Row,Col):-
	checkWinPosition(Board,PieceID,Row,Col).

choosePosition(Board,PieceID,Row,Col):-
	countPieces(N,Board),
	findPosition(N,Board,PieceID,Row,Col).


/*trouvez une position sans aligenement 0-5*/
findPosition(N,Board,PieceID,Row,Col):-
	N<5,N>0,
	optimalPos(0,Board,PieceID,Row,Col)
.


findPosition(N,Board,PieceID,Row,Col):-
	N>5,
	optimalPos(2,Board,PieceID,Row,Col)
.
findPosition(N,Board,PieceID,Row,Col):-
	N>5,
	optimalPos(2,1,Board,PieceID,Row,Col)
.
findPosition(N,Board,PieceID,Row,Col):-
	N>5,
	optimalPos(1,2,Board,PieceID,Row,Col)
.

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(N,N,Board,PieceID,Row,Col).
optimalPos(N1,N2,Board,PieceID,Row,Col):-
	piece(PieceID,Attributes),
	memberchk(FAttribute,Attributes),
	selectListPiece(Row,Board,SelectedRow),
	searchNAttribute(N1,SelectedRow,FAttribute),
	memberchk(SAttribute,Attributes),
	boardRowToCol(Board,ColBoard),
	selectListPiece(Col,ColBoard,SelectedCol),
	searchNAttribute(N2,SelectedCol,SAttribute).

searchNAttribute(N,[],_):-
	N is 0.
searchNAttribute(N,[0|RestOfPieces],Attribute):-
	searchNAttribute(N,RestOfPieces,Attribute).
searchNAttribute(N,[PieceID|RestOfPieces],Attribute):-
	searchAttribute(PieceID,Attribute),
	searchNAttribute(Nr,RestOfPieces,Attribute),
	N is Nr+1.

searchNAttribute(N,[PieceID|RestOfPieces],Attribute):-
	searchNAttribute(N,RestOfPieces,Attribute).
searchAttribute(PieceID,Attribute):-
	piece(PieceID,Attributes),
	memberchk(Attribute,Attributes).

selectListPiece(0,[X|_],X).
selectListPiece(1,[_|[X|_]],X).
selectListPiece(2,[_,_,X,_],X).
selectListPiece(3,[_,_,_,X],X).

boardDiagonal([[W1,X1,Y1,Z1],[W2,X2,Y2,Z2],[W3,X3,Y3,Z3],[W4,X4,Y4,Z4]],[W1,X2,Y3,Z4],[W4,X3,Y2,Z1]).

boardRowToCol([[W1,X1,Y1,Z1],[W2,X2,Y2,Z2],[W3,X3,Y3,Z3],[W4,X4,Y4,Z4]],[[W1,W2,W3,W4],[X1,X2,X3,X4],[Y1,Y2,Y3,Y4],[Z1,Z2,Z3,Z4]]).