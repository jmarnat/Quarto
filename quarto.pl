/*
TODO :
- check win 
- toto
*/



/**************************************
*        SOME INSTANTIATIONS...       *
**************************************/


attribute(color,white,0).
attribute(color,black,1).
attribute(height,short,0).
attribute(height,long,1).
attribute(geometry,round,0).
attribute(geometry,square,1).
attribute(hole,hole,0).
attribute(hole,flat,1).
attribute(empty,nul,' ').

interface(inline).
interface(gui).


piece(0,[nul,nul,nul,nul]).
piece(1,[white,short,round,hole]).
piece(2,[white,short,round,flat]).
piece(3,[white,short,square,hole]).
piece(4,[white,short,square,flat]).
piece(5,[white,long,round,hole]).
piece(6,[white,long,round,flat]).
piece(7,[white,long,square,hole]).
piece(8,[white,long,square,flat]).
piece(9,[black,short,round,hole]).
piece(10,[black,short,round,flat]).
piece(11,[black,short,square,hole]).
piece(12,[black,short,square,flat]).
piece(13,[black,long,round,hole]).
piece(14,[black,long,round,flat]).
piece(15,[black,long,square,hole]).
piece(16,[black,long,square,flat]).




/**************************************
*              GAME PLAY              *
**************************************/
how_to_play :-
	write('just type \'play\' to run the game').

debugHere :- 
	nl,
	write('DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG'),nl,
	write('DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG'),nl,
	write('DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG'),nl.












/*************************
* GAME PLAY BASIC ROUNDS *
*************************/

count_item(_,[],0).
count_item(E,[E|T],N) :-
	count_item(E,T,N2),
	N is N2 + 1.
count_item(E,[E2|T],N) :-
	E \== E2,
	count_item(E,T,N).

test_play(Interface,Heuristics1,Heuristics2,NumTime) :-
	test_play(Interface,Heuristics1,Heuristics2,NumTime,WinnersList),
	count_item(1,WinnersList,N1),
	count_item(2,WinnersList,N2),
	write(Heuristics1),write(' won '),write(N1),write('x\n'),
	write(Heuristics2),write(' won '),write(N2),write('x\n').



test_play(_,_,_,0,[]).
test_play(Interface,Heuristics1,Heuristics2,NumTime,[Winner|Rest]) :-
	round(Interface,[Heuristics1,Heuristics2],[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],1,0,Winner),
	test_play(Interface,Heuristics1,Heuristics2,NumTime2,Rest),
	NumTime is (NumTime2 + 1).


play(inline,Heuristics1,Heuristics2) :-
	heuristics(Heuristics1),
	heuristics(Heuristics2),
	clear,
	round(inline,[Heuristics1,Heuristics2],[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],1,0,_).

play(gui,Heuristics1,Heuristics2) :-
	heuristics(Heuristics1),
	heuristics(Heuristics2),
	init(Heuristics1,[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]),
	round(gui,[Heuristics1,Heuristics2],[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],1,0,_).
	%% free.

play(_,_,_) :-
	write('\e[031mERROE: wrong heuristics name\e[0m').


display_board_int(silent,_).

display_board_int(inline,Board) :-
	draw_board(inline,Board).

display_board_int(gui,Board) :-
	forall(image_id(_,ID),free(ID)),
	display_board(Board),
	display_available_pieces(Board).


printPlayer(silent,_,_).

printPlayer(gui,NumPlayer1,Heuristics1) :-
	printPlayer_inline(NumPlayer1,Heuristics1).

printPlayer(inline,NumPlayer1,Heuristics1) :-
	printPlayer_inline(NumPlayer1,Heuristics1).



round(Interface,_,Board,Winner,_,Winner) :-
	check_win(Board,A,B,C),
	%% wipe,
	printGameOver(Winner,A,B,C),
	display_board_int(Interface,Board).



round(Interface,HeuristicsTab,Board,NumPlayer1,LastPieceID,Winner) :-
	%% wipe,
	display_board_int(Interface,Board),
	getHeuristics(HeuristicsTab,NumPlayer1,Heuristics1),
	printPlayer(Interface,NumPlayer1,Heuristics1),
	askPiece(inline,Heuristics1,Board,PieceID,LastPieceID),

	swapPlayer(NumPlayer1,NumPlayer2),

	%% wipe,
	%% display_board_int
	getHeuristics(HeuristicsTab,NumPlayer2,Heuristics2),
	printPlayer(Interface,NumPlayer2,Heuristics2),

	readPosition(inline,Heuristics2,Board,PieceID,Row,Column),
	putPieceOnBoard(PieceID,Row,Column,Board,NewBoard),
	round(Interface,HeuristicsTab,NewBoard,NumPlayer2,PieceID,Winner).


/******************
* GETTING/SETTING *
******************/

swapPlayer(1,2).
swapPlayer(2,1).


/* CHECKING IF A PLACE IS EMPTY OF NOT*/
getPieceID([FirstRow|_],1,Col,PieceID) :-
	getPieceID_row(FirstRow,Col,PieceID).
getPieceID([_|RestOfRows],Row,Col,PieceID) :-
	getPieceID(RestOfRows,Row2,Col,PieceID),
	Row is (Row2 + 1).

getPieceID_row([PieceID|_],1,PieceID).
getPieceID_row([_|Rest],Col,PieceID) :-
	getPieceID_row(Rest,Col2,PieceID),
	Col is (Col2 + 1).

%% and then we can do :
isEmpty(Board,Row,Col) :-
	getPieceID(Board,Row,Col,0).

isFull(Board,Row,Col) :-
	getPieceID(Board,Row,Col,N),
	N > 0.

putPieceOnBoard(PieceID,1,Column,[FirstLine|T1],[NewFirstLine|T1]) :-
	putPieceOnLine(PieceID,Column,FirstLine,NewFirstLine).

putPieceOnBoard(PieceID,Row,Column,[H|T1],[H|T2]) :-
	putPieceOnBoard(PieceID,Row2,Column,T1,T2),
	Row is (Row2 + 1).


putPieceOnLine(PieceID,1,[_|T],[PieceID|T]).

putPieceOnLine(PieceID,Column,[H|T],[H|T2]) :-
	putPieceOnLine(PieceID,Column2,T,T2),
	Column is (Column2 + 1).



/***************************************
* GETTING ALL PIECES AVAILABLE IN GAME *
***************************************/



isInBoard(Board,PieceID) :-
	getPieceID(Board,_,_,PieceID).


isNotInList([],_).
isNotInList([H|T],Item) :-
	H \= Item,
	isNotInList(T,Item).

isAvailable([],_).
isAvailable([FirstRow|Rest],PieceID) :-
	isNotInList(FirstRow,PieceID),
	isAvailable(Rest,PieceID).





getAvailablePieces(Board,ListOfPieces) :-
	getAvailablePiecesBis(Board,ListOfPieces,1).

getAvailablePiecesBis(_,[],17).
getAvailablePiecesBis(Board,[PieceID|ListOfPieces],PieceID) :-
	PieceID < 17,
	NewPieceID is (PieceID + 1),
	isAvailable(Board,PieceID),
	getAvailablePiecesBis(Board,ListOfPieces,NewPieceID).
getAvailablePiecesBis(Board,ListOfPieces,PieceID) :-
	PieceID < 17,
	NewPieceID is (PieceID + 1),
	isInBoard(Board,PieceID),
	getAvailablePiecesBis(Board,ListOfPieces,NewPieceID).




/*********************
* GAME OVER CHECKING *
*********************/

%% check if an attribute is in a list of the attributes of a piece
is_an_attribute(Attribute,PieceID) :-
	piece(PieceID,ListOfAttributes),
	is_in_attribute_list(Attribute,ListOfAttributes).

is_in_attribute_list(Attribute,[Attribute|_]) :-
	attribute(_,Attribute,0).

is_in_attribute_list(Attribute,[Attribute|_]) :-
	attribute(_,Attribute,1).

is_in_attribute_list(Attribute,[_|T]) :-
	is_in_attribute_list(Attribute,T).

win_list([],_).
win_list([H|T],Attribute) :-
	is_an_attribute(Attribute,H),
	win_list(T,Attribute).


%% checking columns :
check_columns([[A|_],[B|_],[C|_],[D|_]],Attribute,1) :-
	win_list([A,B,C,D],Attribute).
check_columns([[_|T1],[_|T2],[_|T3],[_|T4]],Attribute,Num) :-
	check_columns([T1,T2,T3,T4],Attribute,Num2),
	Num is (Num2 + 1).

%% checking rows :
check_rows([Row|_],Attribute,1) :-
	win_list(Row,Attribute).
check_rows([_|RestOfRows],Attribute,Num) :-
	check_rows(RestOfRows,Attribute,Num2),
	Num is (Num2 + 1).

%% checking first diagonal :
check_first_diagonal([[A|_],[_,B|_],[_,_,C|_],[_,_,_,D]],Attribute) :-
	win_list([A,B,C,D],Attribute).

%% checking second diagonal :
check_second_diagonal([[_,_,_,A],[_,_,B|_],[_,C|_],[D|_]],Attribute) :-
	win_list([A,B,C,D],Attribute).

%% then checking all :
check_win(Board,Attribute,row,Num) :- check_rows(Board,Attribute,Num).
check_win(Board,Attribute,column,Num) :- check_columns(Board,Attribute,Num).
check_win(Board,Attribute,diagonal,1) :- check_first_diagonal(Board,Attribute).
check_win(Board,Attribute,diagonal,2) :- check_second_diagonal(Board,Attribute).
