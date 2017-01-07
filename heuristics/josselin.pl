/* josselin.pl */


askPiece_josselin(inline,Board,PieceID) :-
	chooseBestValuedPiece(Board,PieceID).


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


readPosition_josselin(inline,Board,PieceID,Row,Col) :-
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	check_win(NewBoard,_,_,_).

readPosition_josselin(inline,Board,_,Row,Col) :-
	readPosition_random(inline,Board,_,Row,Col).




numberOfEmptyCells([],0).
numberOfEmptyCells([H|T],N2) :-
	H is 0,
	numberOfEmptyCells(T,N),
	N2 is N + 1.
numberOfEmptyCells([H|T],N) :-
	H \= 0,
	numberOfEmptyCells(T,N).

removeEmptyCells([],[]).
removeEmptyCells([H|T],T2) :-
	H is 0,
	removeEmptyCells(T,T2).
removeEmptyCells([H|T],[H|T2]) :-
	H \= 0,
	removeEmptyCells(T,T2).

areCellsAllEmpty([]).
areCellsAllEmpty([H|T]) :-
	H is 0,
	areCellsAllEmpty(T).


potentialPiece(Board,L,PieceID) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	potentialAttribute(L,Att),
	member(PieceID,ListOfAvailablePieces),
	is_an_attribute(Att,PieceID).


potentialAttribute(L,Att) :-
	numberOfEmptyCells(L,1),
	removeEmptyCells(L,L2),
	win_list(L2,Att).

not_win(Board) :- check_win(Board,_,_,_),!,fail.
not_win(_).



not_member(_Item,[]).
not_member(Item,[H|T]) :-
	Item \== H,
	not_member(Item,T).

clean_list([],[]).

clean_list([],[]).
clean_list([T|C], S) :-
	member(T,C),
	!,
	clean_list(C,S).
clean_list([T|C], [T|Z]) :-
	clean_list(C,Z).


/* check_over */
check_over(ListAttr) :-
	member(A,ListAttr),
	member(B,ListAttr),
	invertAttribute(A,B).

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

