/* inline_interface.pl */
/* J.MARNAT */

/* just a useful predicate to print a space */
space :- write(' ').

/* this is the ascii code to clear a window */
clear :- write('\033[2J').
wipe :- clear, write('\033[0;0H').



/***********************/
/* BOARD ASCII-DRAWING */
/***********************/

draw_middle_line :-
	write('+-----+-----+-----+-----+'), nl.


/* the board will be displayed recusively, row by row */
/* draw_pieces_a is for the two first atributes (0 || 1) */
/* draw_pieces_b is for the two last atributes (0 || 1) */
draw_board(inline,[FirstRow|Tail]) :-
	/* '\e[0Xm' -> change the color in the terminal */
	write('\e[033m'),
	draw_middle_line,
	draw_pieces_a(FirstRow),
	draw_pieces_b(FirstRow),
	draw_pieces_bis(Tail),
	write('\e[0m').

/* the recursion for the pieces display */
draw_pieces_bis([]) :-
	draw_middle_line.
draw_pieces_bis([Row|Tail]) :-
	draw_middle_line,
	draw_pieces_a(Row),
	draw_pieces_b(Row),
	draw_pieces_bis(Tail).

/* take the first piece, get the two first attributes, */
/* display it, and do the same for the rest of the list */
/* until no more pieces are in the list */
draw_pieces_a([FirstPiece|Rest]) :-
	piece(FirstPiece,[P1,P2,_,_]),
	attribute(_,P1,A1),
	attribute(_,P2,A2),
	write('| '),
	write(A1), space,
	write(A2), space,
	draw_pieces_a(Rest).
draw_pieces_a([]) :-
	write('|'),nl.

/* exactly the same thing as before, but with the two last attributes */
draw_pieces_b([FirstPiece|Rest]) :-
	piece(FirstPiece,[_,_,P3,P4]),
	attribute(_,P3,A3),
	attribute(_,P4,A4),
	write('| '),
	write(A3), space,
	write(A4), space,
	draw_pieces_b(Rest).
draw_pieces_b([]) :-
	write('|'),nl.


/* print all the available pieces */
printAvailablePieces(Board) :-
	write('\e[033m'),
	write('Available Pieces :'),
	nl,
	printAvailablePieces(Board,1),
	write('\e[0m'),
	nl.

/* it's the same thing as in the GUI */
printAvailablePieces(_,17).
printAvailablePieces(Board,PieceID) :-
	PieceID < 17,
	NewPieceID is (PieceID + 1),
	isAvailable(Board,PieceID),
	write('\t'),
	write(PieceID),
	write(' :'),
	printPiece(PieceID),nl,
	printAvailablePieces(Board,NewPieceID).
printAvailablePieces(Board,PieceID) :-
	PieceID < 17,
	NewPieceID is (PieceID + 1),
	printAvailablePieces(Board,NewPieceID).

/* print the piece ID, then all the attributes in text, and in binary */
printPiece(PieceID) :-
	piece(PieceID,ListOfAttributes),
	printPieceShort(ListOfAttributes),
	printPieceAttr(ListOfAttributes).

/* print the attributes in a binary-style (ex: 0110) */
printPieceShort(ListOfAttributes) :-
	write(' ('),
	printPieceShort_bis(ListOfAttributes),
	write(') ').
printPieceShort_bis([]).
printPieceShort_bis([FirstAttribute|Rest]) :-
	attribute(_,FirstAttribute,Value),
	write(Value),
	printPieceShort_bis(Rest).

/* print all the attribues of a list */
printPieceAttr([]).
printPieceAttr([FirstAttribute|Rest]) :-
	write(' '),
	write(FirstAttribute),
	printPieceAttr(Rest).

/* just to display which row, col or diagonal there is a win */
numbering(1,'1st').
numbering(2,'2nd').
numbering(3,'3rd').
numbering(4,'4th').

/* printing of a panel to say who won */
printGameOver(Winner,A,B,C) :-
	write('\e[031m*************************************'),nl,
	write('* GAME OVER * GAME OVER * GAME OVER *'),nl,
	write('*************************************'),nl,
	write('Player '),
		write(Winner),
		write(' aligned '),
		write(A),
		write(' pieces on the '),
		numbering(C,C2),
		write(C2),
		space,
		write(B),
	write('\e[0m'),nl.

/* printing the player number and heuristics */
printPlayer_inline(Num,Heuristics) :-
	write('[PLAYER '),
	write(Num),
	write(' - '),
	write(Heuristics),
	write(']\n\n').
