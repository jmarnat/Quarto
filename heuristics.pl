library(random).


askPiece(inline,human,Board,PieceID) :-
	printAvailablePieces(Board),
	write("Enter a piece ID : "),
	read(PieceID),
	isAvailable(Board,PieceID).
	%% debugHere.

askPiece(inline,human,Board,PieceID) :-
	write("This piece is not available! Try again!"),nl,
	askPiece(inline,human,Board,PieceID).




askPiece(inline,random,Board,PieceID) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	random_member(PieceID,ListOfAvailablePieces),
	write("I chose the piece n°"),
	write(PieceID),
	write(" : "),
	printPiece(PieceID),
	nl.




readPosition(inline,human,Board,_,Row,Col) :-
	%% write("")
	write("[row,col]? "),
	read([Row,Col]), 
	Row > 0, Row < 5,
	Col > 0, Col < 5,
	isEmpty(Board,Row,Col).

readPosition(inline,human,Board,PieceID,Row,Col) :-
	write("Nope! Try again..."),nl,
	readPosition(inline,human,Board,PieceID,Row,Col).

readPosition(inline,random,Board,_,Row,Col) :-
	random_member(Row,[1,2,3,4]),
	random_member(Col,[1,2,3,4]),
	isEmpty(Board,Row,Col).

readPosition(inline,random,Board,_,Row,Col) :-
	random_member(Row,[1,2,3,4]),
	random_member(Col,[1,2,3,4]),
	isFull(Board,Row,Col),
	readPosition(inline,random,Board,_,Row,Col).

