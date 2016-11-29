library(random).



getHeuristics([Heuristics1,_],1,Heuristics1).
getHeuristics([_,Heuristics2],2,Heuristics2).

heuristics(human).
heuristics(ai_antho).
heuristics(random).
heuristics(clement).



askPiece(inline,human,Board,PieceID,_) :-
	askPiece_human(inline,Board,PieceID).

askPiece(inline,random,Board,PieceID,_) :-
	askPiece_random(inline,Board,PieceID).

askPiece(inline,ai_antho,Board,PieceID,LastPieceId) :-
	askPiece_ai_antho(inline,Board,PieceID,LastPieceId).




readPosition(inline,human,Board,PieceID,Row,Col) :-
	write('Piece to play : '),printPiece(PieceID),nl,
	readPosition_human(inline,Board,PieceID,Row,Col).

readPosition(inline,random,Board,PieceID,Row,Col) :-
	readPosition_random(inline,Board,PieceID,Row,Col).

readPosition(inline,ai_antho,Board,PieceID,Row,Col) :-
	readPosition_ai_antho(inline,Board,PieceID,Row,Col).
