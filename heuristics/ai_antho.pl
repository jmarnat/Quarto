invertAttribute(white,black).
invertAttribute(black,white).
invertAttribute(short,long).
invertAttribute(long,short).
invertAttribute(round,square).
invertAttribute(square,round).
invertAttribute(hole,flat).
invertAttribute(flat,hole).
try(N):-
	countPieces(N,[[0,2,3,4],[5,0,7,0],[0,0,0,12],[13,0,15,0]])
.		


countPieces(16,[]):-!.
countPieces(Nu,[H|T]):-
	countEmpty(NE,H),	
	countPieces(N,T),
	Nu is N-NE
.
countEmpty(NE,[0|T]):-
	countEmpty(NET,T),
	NE is NET+1
.
countEmpty(NE,[_|T]):-
	countEmpty(NE,T)
.
countEmpty(0,[]).

invertPiece(PieceID,InvertID):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IvColor),
	invertAttribute(Height,IvHeight),
	invertAttribute(Geometry,IvGeometry),
	invertAttribute(Hole,IvHole),
	piece(InvertID,[IvColor,IvHeight,IvGeometry,IvHole])
.
share3(PieceID,[P1,P2,P3,P4]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IvColor),
	invertAttribute(Height,IvHeight),
	invertAttribute(Geometry,IvGeometry),
	invertAttribute(Hole,IvHole),
	piece(P1,[Color,Height,Geometry,IvHole]),
	piece(P2,[Color,Height,IvGeometry,Hole]),
	piece(P3,[Color,IvHeight,Geometry,Hole]),
	piece(P4,[IvColor,Height,Geometry,Hole])
.
share1(PieceID,[P1,P2,P3,P4]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IvColor),
	invertAttribute(Height,IvHeight),
	invertAttribute(Geometry,IvGeometry),
	invertAttribute(Hole,IvHole),
	piece(P1,[IvColor,IVHeight,IvGeometry,Hole]),
	piece(P2,[IvColor,IVHeight,Geometry,IVHole]),
	piece(P3,[IvColor,Height,IvGeometry,IVHole]),
	piece(P4,[Color,IVHeight,IvGeometry,IVHole])
.
share2(PieceID,[P1,P2,P3,P4,P5,P6]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IvColor),
	invertAttribute(Height,IvHeight),
	invertAttribute(Geometry,IvGeometry),
	invertAttribute(Hole,IvHole),
	piece(P1,[Color,Height,IvGeometry,IVHole]),
	piece(P2,[Color,IVHeight,Geometry,IVHole]),
	piece(P3,[Color,IVHeight,IVGeometry,Hole]),
	piece(P4,[IVColor,Height,Geometry,IVHole]),
	piece(P5,[IVColor,Height,IVGeometry,Hole]),
	piece(P6,[IVColor,IVHeight,Geometry,Hole])
.

askPiece_ai_antho(inline,Board,PieceID,MyPieceID):-
	printAvailablePieces(Board),
	countPieces(N,Board),
	givePiece(N,Board,MyPieceID,PieceID),
	goodChoose(Board,PieceID),
	write('I choose :'),write(PieceID),nl,nl,printPiece(PieceID),nl,nl
.

readPosition_ai_antho(inline,Board,PieceID,Row,Col):-
	choosePosition(Board,PieceID,Row,Col)
.
givePiece(0,Board,MyPieceID,FirstPiece):-
	random_member(FirstPiece,[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]).
givePiece(N,Board,MyPieceID,PieceID):-
	N<5,
	invertPiece(MyPieceID,PieceID),
	isAvailable(Board,PieceID)
	.
	

givePiece(N,Board,MyPieceID,PieceID):-
	N<5,
	share1(MyPieceID,PiecesList),
	write(PiecesList),nl,
	chooseAvailable(Board,PieceID,PiecesList)
	.

givePiece(N,Board,MyPieceID,PieceID):-
	write(' Share 3 : '),nl,
	share3(PieceID,PiecesList),
	chooseAvailable(Board,PieceID,PiecesList)
	.
givePiece(N,Board,MyPieceID,PieceID):-
	write(' Share  2 : '),nl,
	share2(PieceID,PiecesList),
	chooseAvailable(Board,PieceID,PiecesList)
	.
givePiece(N,Board,MyPieceID,PieceID):-
	write(' Share 1 : '),nl,
	share1(PieceID,PiecesList),
	chooseAvailable(Board,PieceID,PiecesList)
	.

chooseAvailable(Board,PieceID,[]):-
	fail,!.

chooseAvailable(Board,ID,[ID|_]):-
	read(_),
	isAvailable(Board,ID),
	write(H),write(' is Available'),nl.

chooseAvailable(Board,PieceID,[_|T]):-
	write(T),write(' is rest'),nl,
	chooseAvailable(Board,PieceID,T).	

goodChoose(Board,PieceID):-
	write('Choose : '), write(PieceID), nl,
	piece(PieceID,PieceAtt),
	check_win(Board,Attribute,_,_),
	member(Attribute,PieceAtt),!.