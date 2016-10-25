library(random).

askPiece(inline,random,Board,PieceID) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	random_member(PieceID,ListOfAvailablePieces).

readPosition(inline,random,Board,_,Row,Col) :-
	random_member(Row,[1,2,3,4]),
	random_member(Col,[1,2,3,4]),
	isEmpty(Board,Row,Col).

readPosition(inline,random,Board,_,Row,Col) :-
	random_member(Row,[1,2,3,4]),
	random_member(Col,[1,2,3,4]),
	isFull(Board,Row,Col),
	readPosition(inline,random,Board,_,Row,Col).

