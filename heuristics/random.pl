askPiece_random(inline,Board,PieceID) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	random_member(PieceID,ListOfAvailablePieces),
	write('I chose the piece n°'),
	write(PieceID),
	write(' : '),
	printPiece(PieceID),
	nl.



readPosition_random(inline,Board,_,Row,Col) :-
	random_member(Row,[1,2,3,4]),
	random_member(Col,[1,2,3,4]),
	isEmpty(Board,Row,Col).

readPosition_random(inline,Board,_,Row,Col) :-
	readPosition_random(inline,Board,_,Row,Col).

