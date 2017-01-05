%% josselin.pl


%% askPiece_josselin(inline,Board,PieceID) :-
%% 	%% getAvailablePieces(Board,ListOfAvailablePieces),
%% 	%% random_member(PieceID,ListOfAvailablePieces),
%% 	chooseBestValuedPiece(Board,PieceID),
%% 	write('I chose the piece n°'),
%% 	write(PieceID),
%% 	write(' : '),
%% 	printPiece(PieceID),
	%% nl.

askPiece_josselin(inline,Board,PieceID) :-
	chooseBestValuedPiece(Board,PieceID).
	%% isEmpty(Board,Row,Col),
	%% putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),

	%% chooseBestValuedPiece(NewBoard,NewPieceID),
	%% isEmpty(NewBoard,NewRow,NewCol),
	%% putPieceOnBoard(NewPieceID,NewRow,NewCol,NewBoard,NewNewBoard),
	%% check_win(NewNewBoard,_,_,_),
	%% write('HE WINS !!!!'\n),!.

	%% askPiece_josselin(inline,NewBoard,_PieceID),



chooseBestValuedPiece(Board,PieceID) :-
	findall(PID,valuePiece(Board,PID,1),ListPID),
	member(PieceID,ListPID),
	write('val = 1\n').
chooseBestValuedPiece(Board,PieceID) :-
	valuePiece(Board,PieceID,0),
	write('val = 0\n').



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




/*
invert(_,[],[]).
invert(Attr,[Attr|Rest],[NewAttr|Rest]) :-
	invertAttribute(Attr,NewAttr).
invert(Attr,[Attr1|Rest1],[Attr1|Rest2]) :-
	Attr \== Attr1,
	invert(Attr,Rest1,Rest2).



invert_or_not([],ListAttr,ListAttr).
invert_or_not([Attr|Rest],ListAttr,NewListAttr) :-
	invert(Attr,ListAttr,ListAttr1),
	invert_or_not(Rest,ListAttr1,NewListAttr).


invert_list_attr([],[]).
invert_list_attr([Attr|Rest1],[AttrInv|Rest2]) :-
	invertAttribute(Attr,AttrInv),
	invert_list_attr(Rest1,Rest2).
*/

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




/* i'm forced to lose here */
valuePiece(Board,PieceID,-1000) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	member(PieceID,ListOfAvailablePieces),

	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	check_win(NewBoard,_,_,_).

/* this piece can't makes me lose */
valuePiece(Board,PieceID,1) :-
	find_secure_piece(Board,PieceID).

valuePiece(Board,PieceID,0) :-
	askPiece_random(inline,Board,PieceID).





valuePiece(Board,PieceID,0) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	member(PieceID,ListOfAvailablePieces).

/*
findWinningAttributes(_,[]).
findWinningAttributes(Board,[Attribute|ListOfAttributes]) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	member(PieceID,ListOfAvailablePieces),
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),

	check_win(NewBoard,Attribute,_,_),
	not(member(Attribute,ListOfAttributes)),
	findWinningAttributes(Board,ListOfAttributes).
*/
