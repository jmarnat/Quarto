/* josselin.pl */

/* the predicate needed by the game */
/* will return an optimal piece to give to the next player */
askPiece_josselin(inline,Board,PieceID) :-
	chooseBestValuedPiece(Board,PieceID).

/* idem for the position */
readPosition_josselin(inline,Board,PieceID,Row,Col) :-
	chooseBestValuedPosition(Board,PieceID,Row,Col).



/*--------------------------*/
/* SELECTING THE BEST PIECE */
/*--------------------------*/

/* we choose the best piece by getting the piece */
/* with the highest value associated */
chooseBestValuedPiece(Board,PieceID) :-
	findall(PID,valuePiece(Board,PID,1),ListPID),
	member(PieceID,ListPID),
	write('val = 1\n').
chooseBestValuedPiece(Board,PieceID) :-
	valuePiece(Board,PieceID,0),
	write('val = 0\n').
chooseBestValuedPiece(Board,PieceID) :-
	valuePiece(Board,PieceID,-1000),
	write('val = -1000\n').




/* this will remove items of the first list in the second one */
/* (used in winning_attributes_list) */
clean_list([],[]).
clean_list([T|C], S) :-
	member(T,C),
	!,
	clean_list(C,S).
clean_list([T|C], [T|Z]) :-
	clean_list(C,Z).


winning_attributes_list(Board,ListAttr) :-
	findall(Attr,winning_attributes(Board,Attr),ListAttr1),
	clean_list(ListAttr1,ListAttr).

/* list of attributes who makes a board losable */
winning_attributes(Board,Attr) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	member(PieceID,ListOfAvailablePieces),
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	check_win(NewBoard,Attr,_,_).



find_piece_without_attributes(Board,ListAttr,PieceID) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	member(PieceID,ListOfAvailablePieces),
	piece(PieceID,[A,B,C,D]),
	not(member(A,ListAttr)),
	not(member(B,ListAttr)),
	not(member(C,ListAttr)),
	not(member(D,ListAttr)).


/* THIS IS the interesting function: 
- get a piece which are not a danger to give to the other player */
find_secure_piece(Board,PieceID) :-
	findall(PieceIDTmp,find_secure_piece_bis(Board,PieceIDTmp),PieceIDList),
	member(PieceID,PieceIDList).

find_secure_piece_bis(Board,PieceID) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	member(PieceID,ListOfAvailablePieces),
	winning_attributes_list(Board,ListAttr),
	find_piece_without_attributes(Board,ListAttr,PieceID).


/* this piece is forced to make me win */
valuePiece(Board,PieceID,1000) :-
	%% first, for every position, the next player can't win
	isEmpty(Board,Row,Col),
	forall(putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),not(check_win(NewBoard,_,_,_))),

	%% then, whatever the piece he gives me, i'll win
	getAvailablePieces(NewBoard,ListOfAvailablePieces),
	member(NewPID,ListOfAvailablePieces),
	forall(putPieceOnBoard(NewPID,_,_,NewBoard,NewNewBoard),check_win(NewNewBoard,_,_,_))
.

/* this piece can't makes me lose */
valuePiece(Board,PieceID,1) :-
	find_secure_piece(Board,PieceID).

/* if i can't win, just select a piece randomly */
valuePiece(Board,PieceID,0) :-
	askPiece_random(inline,Board,PieceID).

/* i'm forced to lose here */
/* in fact, this should never happend */
valuePiece(Board,PieceID,-1000) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	member(PieceID,ListOfAvailablePieces),
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	check_win(NewBoard,_,_,_).


/*-----------------------------*/
/* SELECTING THE BEST POSITION */
/*-----------------------------*/
chooseBestValuedPosition(Board,PieceID,Row,Col) :-
	valuePosition(Board,PieceID,Row,Col,1000),
	write(1000).
chooseBestValuedPosition(Board,PieceID,Row,Col) :-
	valuePosition(Board,PieceID,Row,Col,1),
	write(1).
chooseBestValuedPosition(Board,PieceID,Row,Col) :-
	valuePosition(Board,PieceID,Row,Col,0),
	write(0).

/* succeed if we win with this position */
valuePosition(Board,PieceID,Row,Col,1000) :-
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	check_win(NewBoard,_,_,_).

/* succeed if i can win next time */
/* (two long to be efficient -> deactivated ) */
valuePosition(Board,PieceID,Row,Col,100) :-
	/* my round */
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	
	/* other player's round */
	getAvailablePieces(NewBoard,ListOfAvailablePieces),
	member(NewPieceID,ListOfAvailablePieces),
	isEmpty(NewBoard,NewRow,NewCol),
	putPieceOnBoard(NewPieceID,NewRow,NewCol,NewBoard,NewNewBoard),
	not(check_win(NewNewBoard,_,_,_)),

	/* my round again */
	getAvailablePieces(NewNewBoard,NNListOfAvailablePieces),
	member(NNPieceID,NNListOfAvailablePieces),
	isEmpty(NewNewBoard,NNRow,NNCol),
	putPieceOnBoard(NNPieceID,NNRow,NNCol,NewNewBoard,NNNBoard),
	check_win(NNNBoard,_,_,_).


/* succeed if the next player can't win next round */
valuePosition(Board,PieceID,Row,Col,1) :-
	/* my round */
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	
	/* other player's round */
	getAvailablePieces(NewBoard,ListOfAvailablePieces),
	member(NewPieceID,ListOfAvailablePieces),
	isEmpty(NewBoard,NewRow,NewCol),
	putPieceOnBoard(NewPieceID,NewRow,NewCol,NewBoard,NewNewBoard),
	not(check_win(NewNewBoard,_,_,_)).

/* succeed otherwise (random) */
valuePosition(Board,_,Row,Col,0) :-
	readPosition_random(inline,Board,_,Row,Col).




