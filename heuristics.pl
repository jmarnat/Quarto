library(random).


askPiece(inline,human,Board,PieceID) :-
	askPiece_human(inline,Board,PieceID).

askPiece(inline,random,Board,PieceID) :-
	askPiece_random(inline,Board,PieceID).





readPosition(inline,human,Board,PieceID,Row,Col) :-
	readPosition_human(inline,Board,PieceID,Row,Col).

readPosition(inline,random,Board,PieceID,Row,Col) :-
	readPosition_random(inline,Board,PieceID,Row,Col).
