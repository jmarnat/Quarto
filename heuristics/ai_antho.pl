invertAttribute(white,black).
invertAttribute(black,white).
invertAttribute(short,long).
invertAttribute(long,short).
invertAttribute(round,square).
invertAttribute(square,round).
invertAttribute(hole,flat).
invertAttribute(flat,hole).
try(N):-
	countPieces(N,[[0,2,3,4],[5,0,7,0],[0,0,0,12],[13,0,15,0]]).		


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
	getLoosesPiecesBis(Board,ListOfPieces,1).

getLoosesPiecesBis(_,[],17).
getLoosesPiecesBis(Board,[PieceID|ListOfPieces],PieceID) :-
	PieceID < 17,
	NewPieceID is (PieceID + 1),
	isLooses(Board,PieceID),
	getLoosesPiecesBis(Board,ListOfPieces,NewPieceID).
getLoosesPiecesBis(Board,ListOfPieces,PieceID) :-
	PieceID < 17,
	NewPieceID is (PieceID + 1),
	getLoosesPiecesBis(Board,ListOfPieces,NewPieceID).
isLooses(Board,PieceID):-
	piece(TestPieceID,_),
	putPieceOnBoard(TestPieceID,_,_,Board,NewBoard),
	check_win(NewBoard,_,_,_),
	PieceID is TestPieceID.


askPiece_ai_antho(inline,Board,PieceID,MyPieceID):-
	printAvailablePieces(Board),
	countPieces(N,Board),
	getLoosesPieces(Board,LoosePieces),
	getAvailablePieces(Board,AvailablePieces),

	write(loosePieces),write(LoosePieces),nl,
	givePiece(N,MyPieceID,PieceID,AvailablePieces,LoosePieces),
	write('I choose :'),write(PieceID),nl,nl,printPiece(PieceID),nl,nl.

readPosition_ai_antho(inline,Board,PieceID,Row,Col):-
	choosePosition(Board,PieceID,Row,Col).
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
	member(PieceID,AvailablePieces),
	\+member(PieceID,LoosePieces).

findPiece(_,_,RandomPiece,AvailablePieces):-
	random_member(RandomPiece,AvailablePieces).
findPiece(N,MyPieceID,PieceID):-
	N>0,N<5,
	invertPiece(MyPieceID,PieceID).
findPiece(N,MyPieceID,PieceID):-
	N>0,N<5,
	share1(MyPieceID,PiecesList),
	member(PieceID,PiecesList),
	write(PiecesList),nl.
findPiece(N,MyPieceID,PieceID):-
	N>4,
	write(' Share 3 : '),nl,
	share3(MyPieceID,PiecesList),
	member(PieceID,PiecesList),
	write(PiecesList),nl.
findPiece(N,MyPieceID,PieceID):-
	N>4,
	write(' Share  2 : '),nl,
	share2(MyPieceID,PiecesList),
	member(PieceID,PiecesList),
	write(PiecesList),nl.
findPiece(N,MyPieceID,PieceID):-
	N>4,
	write(' Share 1 : '),nl,
	share1(MyPieceID,PiecesList),
	member(PieceID,PiecesList),
	write(PiecesList),nl.