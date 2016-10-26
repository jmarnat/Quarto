space :- write(' ').

clear :- write('\033[2J').
wipe :- clear, write('\033[0;0H').

draw_middle_line :-
	write('+-----+-----+-----+-----+'), nl.

draw_board(inline,[FirstRow|Tail]) :-
	write('\e[033m'),
	draw_middle_line,
	draw_pieces_a(FirstRow),
	draw_pieces_b(FirstRow),
	draw_pieces_bis(Tail),
	write('\e[0m').

draw_pieces_bis([]) :-
	draw_middle_line.

draw_pieces_bis([Row|Tail]) :-
	draw_middle_line,
	draw_pieces_a(Row),
	draw_pieces_b(Row),
	draw_pieces_bis(Tail).

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


printAvailablePieces(Board) :-
	write('\e[033m'),
	write('Available Pieces :'),
	nl,
	printAvailablePiecesBis(Board,1),
	write('\e[0m'),
	nl.





printAvailablePiecesBis(_,17).
printAvailablePiecesBis(Board,PieceID) :-
	PieceID < 17,
	NewPieceID is (PieceID + 1),
	isAvailable(Board,PieceID),
	write('\t'),
	write(PieceID),
	write(' ('),
	printPiece(PieceID),
	write(')'),nl,
	printAvailablePiecesBis(Board,NewPieceID).
printAvailablePiecesBis(Board,PieceID) :-
	PieceID < 17,
	NewPieceID is (PieceID + 1),
	printAvailablePiecesBis(Board,NewPieceID).

printPiece(PieceID) :-
	piece(PieceID,ListOfAttributes),
	printPieceBis(ListOfAttributes).

printPieceBis([]).
printPieceBis([FirstAttribute|Rest]) :-
	attribute(_,FirstAttribute,Value),
	write(Value),
	printPieceBis(Rest).


numbering(1,"1st").
numbering(2,"2nd").
numbering(3,"3rd").
numbering(4,"4th").


printGameOver(Winner,A,B,C) :-
	write('\e[031m*************************************'),nl,
	write('* GAME OVER * GAME OVER * GAME OVER *'),nl,
	write('*************************************'),nl,
	%% draw_board(inline,Board)
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

printPlayer(Num,Heuristics) :-
	%% Heuristics =.. HeuristicsName
	write('[PLAYER '),
	write(Num),
	write(' - '),
	write(Heuristics),
	write(']\n\n').
