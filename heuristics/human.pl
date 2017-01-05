askPiece_human(inline,Board,PieceID) :-
	printAvailablePieces(Board),
	write('Enter a piece ID : '),
	read(PieceID),
	isAvailable(Board,PieceID).

askPiece_human(inline,Board,PieceID) :-
	write('This piece is not available! Try again!'),nl,
	askPiece_human(inline,Board,PieceID).




readPosition_human(inline,Board,_,Row,Col) :-
	write('[row,col]? '),
	read([Row,Col]), 
	Row > 0, Row < 5,
	Col > 0, Col < 5,
	isEmpty(Board,Row,Col).

readPosition_human(inline,Board,PieceID,Row,Col) :-
	write('Nope! Try again...'),nl,
	readPosition_human(inline,Board,PieceID,Row,Col).
