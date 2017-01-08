/* quarto.pl */
/* J.MARNAT */


/**************************************
*        SOME INSTANTIATIONS...       *
**************************************/

/* definition of all the attributes */
attribute(empty,nul,' ').
attribute(color,white,0).
attribute(color,black,1).
attribute(height,short,0).
attribute(height,long,1).
attribute(geometry,round,0).
attribute(geometry,square,1).
attribute(hole,hole,0).
attribute(hole,flat,1).

interface(silent).
interface(inline).
interface(gui).


/* definition of all pieces */
/* the piece num 0 means an empty cell in the board */
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
/* this will display a little helper on how to start */
how_to_play :-
	write('just type \'play\'(interface,heuristics1,Heuristics2) to run the game\n'),
	write('- interface = inline | gui\n'),
	write('- heuristics1X = human | random | josselin | clement | anthony | jeremie\n\n'),
	write('Enjoy the game!\n').

/* sometimes we needed to see if a part of the programe was indeed executed */
/* this predicate is here to debug our code */
debugHere :- 
	nl,
	write('DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG'),nl,
	write('DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG'),nl,
	write('DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG'),nl.






/***************
* GAME TESTING *
***************/

/* this will count items equals to E in a list */
/* used in test_play to display how many time each player wins */
count_item(_,[],0).
count_item(E,[E|T],N) :-
	count_item(E,T,N2),
	N is N2 + 1.
count_item(E,[E2|T],N) :-
	E \== E2,
	count_item(E,T,N).

/* execute NumTime times a game with some heuristics, */
/* and then display the time, memory, CPU usage of the execution */
stats(Heuristics1,Heuristics2,NumTime) :-
	time(test_play(silent,Heuristics1,Heuristics2,NumTime)).

test_play(Interface,Heuristics1,Heuristics2,NumTime) :-
	test_play(Interface,Heuristics1,Heuristics2,NumTime,WinnersList),
	count_item(1,WinnersList,N1),
	count_item(2,WinnersList,N2),
	write(Heuristics1),write(' won '),write(N1),write('x\n'),
	write(Heuristics2),write(' won '),write(N2),write('x\n').



/* this is the predicate who actually runs the game NumTime times */
/* it runs the game, then decrement NumTime, and call itself until NumTime = 0 */
test_play(_,_,_,0,[]).
test_play(Interface,Heuristics1,Heuristics2,NumTime,[Winner|Rest]) :-
	round(Interface,[Heuristics1,Heuristics2],[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],1,0,Winner),
	test_play(Interface,Heuristics1,Heuristics2,NumTime2,Rest),
	NumTime is (NumTime2 + 1).




/*********************************************
* SOME USEFULL predicateS USED FOR THE ROUNDS *
*********************************************/

/* just remaping the display_board predicates */
display_board_int(inline,Board) :-
	wipe,
	draw_board(inline,Board).

display_board_int(gui,Board) :-
	forall(image_id(_,ID),free(ID)),
	display_board(Board),
	display_available_pieces(Board).

display_board_int(_,_).


/* remaping the print_Player (GUI vs. inline) */
printPlayer(gui,NumPlayer1,Heuristics1) :-
	display_player(NumPlayer1,Heuristics1).

printPlayer(inline,NumPlayer1,Heuristics1) :-
	printPlayer_inline(NumPlayer1,Heuristics1).

printPlayer(_,_,_).

/* and the same for display_piece */
display_piece_to_play_int(gui,PieceID) :-
	display_piece_to_play(PieceID).
display_piece_to_play_int(_,_).

/* to do a sleep of 1sec when running the GUI with no human */
get_sleep(gui,[H1,H2],1) :-
	H1 \== human,
	H2 \== human.
get_sleep(_,_,0).



/********************************
* GAME PLAY : THE ACTUAL ROUNDS *
********************************/

/* running the game graphically */
play(gui,Heuristics1,Heuristics2) :-
	heuristics(Heuristics1),
	heuristics(Heuristics2),
	init(Heuristics1,[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]),
	round(gui,[Heuristics1,Heuristics2],[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],1,0,_).

/* otherwise, just running the first round */
play(Interface,Heuristics1,Heuristics2) :-
	heuristics(Heuristics1),
	heuristics(Heuristics2),
	clear,
	round(Interface,[Heuristics1,Heuristics2],[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],1,0,_).

/* is something's wrong in the inputs of this predicate, it'll display an error */
play(I,H1,H2) :-
	write('\e[031mERROR: wrong heuristics name : play('),
	write(I),write(','),
	write(H1),write(','),
	write(H2),write(')\e[0m').



/* checking if someone actually won */
round(Interface,_,Board,Winner,_,Winner) :-
	check_win(Board,A,B,C),
	display_board_int(Interface,Board),
	printGameOver(Winner,A,B,C).

/* checking if the board is full = no winner */
round(_Interface,_,Board,_,_,0) :-
	getAvailablePieces(Board,ListOfPieces),
	length(ListOfPieces,0),
	write('!! NOBODY WINS !!').

/* otherwise, just do an other round */
round(Interface,HeuristicsTab,Board,NumPlayer1,LastPieceID,Winner) :-
	/* first we display the board, the player */
	display_board_int(Interface,Board),
	getHeuristics(HeuristicsTab,NumPlayer1,Heuristics1),
	printPlayer(Interface,NumPlayer1,Heuristics1),

	/* this will return the piece selected by the player */
	askPiece(inline,Heuristics1,Board,PieceID,LastPieceID),

	/* then, it's time to the other player to do his move */
	swapPlayer(NumPlayer1,NumPlayer2),
	display_piece_to_play_int(Interface,PieceID),
	getHeuristics(HeuristicsTab,NumPlayer2,Heuristics2),
	printPlayer(Interface,NumPlayer2,Heuristics2),
	readPosition(inline,Heuristics2,Board,PieceID,Row,Column),

	/* we put the piece selected by Player1 at the location of player 2 on the board */
	putPieceOnBoard(PieceID,Row,Column,Board,NewBoard),

	/* this is to animate the play graphically if nobody's human */
	get_sleep(Interface,HeuristicsTab,Sleep),
	sleep(Sleep),

	/* now's the time to do the next round */
	round(Interface,HeuristicsTab,NewBoard,NumPlayer2,PieceID,Winner).




/******************
* GETTING/SETTING *
******************/

swapPlayer(1,2).
swapPlayer(2,1).


getPieceID([FirstRow|_],1,Col,PieceID) :-
	getPieceID_row(FirstRow,Col,PieceID).
getPieceID([_|RestOfRows],Row,Col,PieceID) :-
	getPieceID(RestOfRows,Row2,Col,PieceID),
	Row is (Row2 + 1).

getPieceID_row([PieceID|_],1,PieceID).
getPieceID_row([_|Rest],Col,PieceID) :-
	getPieceID_row(Rest,Col2,PieceID),
	Col is (Col2 + 1).

/* check if a cell is empty */
/* -> true if the value in the cell is 0 */
isEmpty(Board,Row,Col) :-
	getPieceID(Board,Row,Col,0).

/* check if a cell is full */
/* -> trus if the value is greater than 0 */
isFull(Board,Row,Col) :-
	getPieceID(Board,Row,Col,N),
	N > 0.

/* this predicate is important */
/* it takes the piece, and "put it on the board", recursively */
/* in reality, it succeed if the NewBoard is the Board, with the piece */
/* PieceID at the col Column and row Row */
/* */
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

/* succeed if the piece is on the board */
isInBoard(Board,PieceID) :-
	getPieceID(Board,_,_,PieceID).

/* succeed if the Item is not in the list */
isNotInList([],_).
isNotInList([H|T],Item) :-
	H \= Item,
	isNotInList(T,Item).

/* this will succeed if a piece is available in the game */
isAvailable([],_).
isAvailable([FirstRow|Rest],PieceID) :-
	isNotInList(FirstRow,PieceID),
	isAvailable(Rest,PieceID).


/* returns all the available pieces of the game */
getAvailablePieces(Board,ListOfPieces) :-
	getAvailablePiecesBis(Board,ListOfPieces,1).

/* it'll check the availability of all pieces from 1 to 16 inclueded */
/* if they're availables, we add the piece in the list */
/* otherwise, we check with the next one */
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

/* check if an attribute is in a list of the attributes of a piece */
/* ex : is_an_attribute(white,1). or is_an_attribute(short,11). */
is_an_attribute(Attribute,PieceID) :-
	piece(PieceID,ListOfAttributes),
	is_in_attribute_list(Attribute,ListOfAttributes).

/* this will succeed if an attribute is in the list */
is_in_attribute_list(Attribute,[Attribute|_]) :-
	attribute(_,Attribute,0).

is_in_attribute_list(Attribute,[Attribute|_]) :-
	attribute(_,Attribute,1).

is_in_attribute_list(Attribute,[_|T]) :-
	is_in_attribute_list(Attribute,T).


/* this will succeed if all the pieces in the list */
/* are sharing the common attribute Attribute */
win_list([],_).
win_list([PieceID|RestOfPieces],Attribute) :-
	is_an_attribute(Attribute,PieceID),
	win_list(RestOfPieces,Attribute).


/* checking columns by checking if win_list succeed */
/* with the first element of any row */
/* of course, this will stop either on the first success (then TRUE) */
/* or when the board will be empty (then FALSE) */
check_columns([[A|_],[B|_],[C|_],[D|_]],Attribute,1) :-
	win_list([A,B,C,D],Attribute).

/* otherwise, call itself with the board minus the first */
/* elements of each row */
check_columns([[_|T1],[_|T2],[_|T3],[_|T4]],Attribute,Num) :-
	check_columns([T1,T2,T3,T4],Attribute,Num2),
	Num is (Num2 + 1).


/* checking rows is easier : we just have to check if win_list */
/* succeed with any row */
check_rows([Row|_],Attribute,1) :-
	win_list(Row,Attribute).

check_rows([_|RestOfRows],Attribute,Num) :-
	check_rows(RestOfRows,Attribute,Num2),
	Num is (Num2 + 1).


/* checking first diagonal : almost the same thing that */
/* check_columns, but we're selecting manually the four cells to check */
check_first_diagonal([[A|_],[_,B|_],[_,_,C|_],[_,_,_,D]],Attribute) :-
	win_list([A,B,C,D],Attribute).

/* checking second diagonal, same thing as the previous one */
check_second_diagonal([[_,_,_,A],[_,_,B|_],[_,C|_],[D|_]],Attribute) :-
	win_list([A,B,C,D],Attribute).


/* then, we check all the four predicates in check_win */
check_win(Board,Attribute,row,Num) :- check_rows(Board,Attribute,Num).
check_win(Board,Attribute,column,Num) :- check_columns(Board,Attribute,Num).
check_win(Board,Attribute,diagonal,1) :- check_first_diagonal(Board,Attribute).
check_win(Board,Attribute,diagonal,2) :- check_second_diagonal(Board,Attribute).
