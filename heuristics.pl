library(random).


askPiece(inline,human,Board,PieceID,LastPieceId) :-
	askPiece_human(inline,Board,PieceID,LastPieceId).

askPiece(inline,random,Board,PieceID,LastPieceId) :-
	askPiece_random(inline,Board,PieceID,LastPieceId).

askPiece(inline,ai_antho,Board,PieceID,LastPieceId) :-
	askPiece_ai_antho(inline,Board,PieceID,LastPieceId).




readPosition(inline,human,Board,PieceID,Row,Col) :-
	readPosition_human(inline,Board,PieceID,Row,Col).

readPosition(inline,random,Board,PieceID,Row,Col) :-
	readPosition_random(inline,Board,PieceID,Row,Col).

readPosition(inline,ai_antho,Board,PieceID,Row,Col) :-
	readPosition_human(inline,Board,PieceID,Row,Col).
