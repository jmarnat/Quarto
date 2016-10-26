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


countPieces(16,[]):-	!.
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

askPiece_ai_antho(inline,Board,PieceID).

readPosition_ai_antho(inline,Board,PieceID,Row,Col).