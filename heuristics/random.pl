/* random.pl */
/* J.MARNAT */

/* returning randomly a piece among the available ones */
askPiece_random(inline,Board,PieceID) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	random_member(PieceID,ListOfAvailablePieces),
	write('I chose the piece n°'),
	write(PieceID),
	write(' : '),
	printPiece(PieceID),
	nl.


/* here we choose a random cell on the board */
readPosition_random(inline,Board,_,Row,Col) :-
	random_member(Row,[1,2,3,4]),
	random_member(Col,[1,2,3,4]),
	isEmpty(Board,Row,Col).

/* and doing this because random_member won't backtrack ! */
readPosition_random(inline,Board,_,Row,Col) :-
	readPosition_random(inline,Board,_,Row,Col).

