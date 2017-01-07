cell_id(0,0,@cell1).
cell_id(0,1,@cell2).
cell_id(0,2,@cell3).
cell_id(0,3,@cell4).
cell_id(1,0,@cell5).
cell_id(1,1,@cell6).
cell_id(1,2,@cell7).
cell_id(1,3,@cell8).
cell_id(2,0,@cell9).
cell_id(2,1,@cell10).
cell_id(2,2,@cell11).
cell_id(2,3,@cell12).
cell_id(3,0,@cell13).
cell_id(3,1,@cell14).
cell_id(3,2,@cell15).
cell_id(3,3,@cell16).

image_id(1,@image1).
image_id(2,@image2).
image_id(3,@image3).
image_id(4,@image4).
image_id(5,@image5).
image_id(6,@image6).
image_id(7,@image7).
image_id(8,@image8).
image_id(9,@image9).
image_id(10,@image10).
image_id(11,@image11).
image_id(12,@image12).
image_id(13,@image13).
image_id(14,@image14).
image_id(15,@image15).
image_id(16,@image16).

text_id(1,@text1).
text_id(2,@text2).
text_id(3,@text3).
text_id(4,@text4).
text_id(5,@text5).
text_id(6,@text6).
text_id(7,@text7).
text_id(8,@text8).
text_id(9,@text9).
text_id(10,@text10).
text_id(11,@text11).
text_id(12,@text12).
text_id(13,@text13).
text_id(14,@text14).
text_id(15,@text15).
text_id(16,@text16).


init(FirstHeuristics,Board) :-
	free,
	init_window(),
	display_grid(),
	display_player(1,FirstHeuristics),
	display_board(Board),
	display_available_pieces(Board).


init_window() :-
	new(@window, window('Quarto',size(560,700))),
	send(@window, open),
	send(@window, display, new(@bg, box(560,700)),point(0,0)),
	send(@bg, fill_pattern, colour(black)).
	%% send(@window, display, new(@button1,button(get_cell,message(@prolog,get_cell,2,3)))).

get_cell(Row,Col) :-
	write('ROW : '), write(Row), nl,
	write('COL : '), write(Col), nl.

decay(PieceID,15) :-
	PieceID =< 4.
decay(PieceID,15) :-
	PieceID >= 9,
	PieceID =< 12.
decay(_,0).

free_or_not(P) :- free(P).
free_or_not(_).

display_player(Num,Heuristics) :-
	atom_concat('Player ',Num,Txt1),
	atom_concat(Txt1,' (',Txt2),
	atom_concat(Txt2,Heuristics,Txt3),
	atom_concat(Txt3,')',Txt),
	free_or_not(@textplayer),
	send(@window, display, new(@textplayer, text(Txt)), point(120, 50)),
	send(@textplayer,colour,colour(white)),
	send(@textplayer,font,font(helvetica,roman,15)).


display_piece_onboard(0,_,_).
display_piece_onboard(PieceID,X,Y) :-
	decay(PieceID,D),
	XScaled is 100 + (X * 100) + D,
	YScaled is 100 + (Y * 100),
	display_piece(PieceID,XScaled,YScaled).

display_piece_to_play(PieceID) :-
	image_id(PieceID,ID),
	free(ID),
	display_piece(PieceID,10,10).



display_piece(PieceID,XScaled,YScaled) :-
	atom_concat('images/',PieceID,Path1),
	atom_concat(Path1,'.xpm',Path),
	image_id(PieceID,ImageID),
	send(@window,display,new(ImageID,bitmap(Path)),point(YScaled,XScaled)),
	send(ImageID,recogniser,click_gesture(left,'',single,message(@prolog,clicked_piece,PieceID))).

/*
	text_id(PieceID,TextID),
	XText is XScaled + 50,
	YText is YScaled + 10,
	send(@window,display,new(TextID,text(PieceID)),point(XText,YText)),
	send(TextID,colour,colour(gray)),
	send(TextID,font,font(helvetica,roman,1)).
*/
display_cell(X,Y) :-
	cell_id(X,Y,ImageID),
	XScaled is 90 + (X * 100),
	YScaled is 70 + (Y * 100),
	send(@window,display,new(ImageID,bitmap('images/black.xpm')),point(YScaled,XScaled)),
	send(ImageID,recogniser,click_gesture(left,'',single,message(@prolog,clicked_cell,X,Y))).

clicked_cell(X,Y) :-
	write('['),
	%% write('the cell '),
	write(X),write(','),write(Y),
	%% write(' has been selected !\n').
	write('].'),nl.

clicked_piece(PieceID) :-
	%% 
	%% write('the piece '),
	write(PieceID),write('.\n').
	%% write(' has been selected !\n').


display_test :-
	display_piece_onboard(1,0,0),
	display_piece_onboard(2,0,1),
	display_piece_onboard(3,0,2),
	display_piece_onboard(4,0,3),
	display_piece_onboard(5,1,0),
	display_piece_onboard(6,1,1),
	display_piece_onboard(7,1,2),
	display_piece_onboard(8,1,3),
	display_piece_onboard(9,2,0),
	display_piece_onboard(10,2,1),
	display_piece_onboard(11,2,2),
	display_piece_onboard(12,2,3),
	display_piece_onboard(13,3,0),
	display_piece_onboard(14,3,1),
	display_piece_onboard(15,3,2),
	display_piece_onboard(16,3,3).

display_grid :-
	display_rows(0),
	display_cols(0).

display_rows(5).
display_rows(N) :-
	Y is 90 + N * 100,
	X1 is 70,
	X2 is 470,
	send(@window,display,new(LineID,line(X1,Y,X2,Y))),
	send(LineID,colour,colour(gray)),
	N2 is N + 1,
	display_rows(N2).

display_cols(5).
display_cols(N) :-
	X is 70 + N * 100,
	Y1 is 90,
	Y2 is 490,
	send(@window,display,new(LineID,line(X,Y1,X,Y2))),
	send(LineID,colour,colour(gray)),
	N2 is N + 1,
	display_cols(N2).


display_board(Board) :-
	display_board(0,Board).

display_board(_,[]).
display_board(NumLine,[FirstLine|Rest]) :-
	display_line(NumLine,0,FirstLine),
	NumLine2 is NumLine + 1,
	display_board(NumLine2,Rest).

display_line(_,_,[]).
display_line(NumLine,NumCol,[FirstCell|Rest]) :-
	display_piece_onboard(FirstCell,NumLine,NumCol),
	NumCol2 is NumCol + 1,
	display_line(NumLine,NumCol2,Rest).


display_available_pieces(Board) :-
	getAvailablePieces(Board,ListOfPieces),
	get_white_pieces(ListOfPieces,WhitePiecesIDs),
	get_black_pieces(ListOfPieces,BlackPiecesIDs),
	display_available_pieces_bis(0,WhitePiecesIDs),
	display_available_pieces_bis(80,BlackPiecesIDs).

display_available_pieces_bis(DecayX,WhitePiecesIDs) :-
	length(WhitePiecesIDs,N),
	DecayY is (8 - N) * 30,
	display_available_pieces_row(0,DecayX,DecayY,WhitePiecesIDs).

display_available_pieces_row(_,_,_,[]).
display_available_pieces_row(N,DecayX,DecayY,[PieceID|Rest]) :-
	decay(PieceID,D),
	X is DecayX + 520 + D,
	Y is (30 + DecayY + (60 * N)),
	display_piece(PieceID,X,Y),
	N2 is N + 1,
	display_available_pieces_row(N2,DecayX,DecayY,Rest).




get_white_pieces([],[]).
get_white_pieces([PieceID|Rest],[PieceID|Rest2]) :-
	piece(PieceID,[white,_,_,_]),
	get_white_pieces(Rest,Rest2).
get_white_pieces([_PieceID|Rest],L2) :-
	get_white_pieces(Rest,L2).

get_black_pieces([],[]).
get_black_pieces([PieceID|Rest],[PieceID|Rest2]) :-
	piece(PieceID,[black,_,_,_]),
	get_black_pieces(Rest,Rest2).
get_black_pieces([_PieceID|Rest],L2) :-
	get_black_pieces(Rest,L2).



free :-
	forall(image_id(_,ID),free(ID)),
	forall(cell_id(_,_,ID),free(ID)),
	forall(text_id(_,ID),free(ID)),
	free(@textplayer),
	free(@window),
	free(@bg).




