askPiece_clement(inline,Board,PieceID,_LastPieceId) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	get_list_win(Board,ListWin),
	not(member([Carac,_,_],ListWin)),
	piece(PieceID,[Carac,_,_,_]),
	not(member([Carac1,_,_],ListWin)),
	piece(PieceID,[_,Carac1,_,_]),
	not(member([Carac2,_,_],ListWin)),
	piece(PieceID,[_,_,Carac2,_]),
	not(member([Carac3,_,_],ListWin)),
	piece(PieceID,[_,_,_,Carac3]),
	random_member(PieceID,ListOfAvailablePieces).
		
askPiece_clement(inline,Board,PieceID) :-
	getAvailablePieces(Board,ListOfAvailablePieces),
	random_member(PieceID,ListOfAvailablePieces),
	write('I chose the piece n°'),
	write(PieceID),
	write(' : '),
	printPiece(PieceID),
	nl.

readPosition_clement(inline,Board,PieceID,Row,Col) :-
	get_list_win(Board,ListWin),
	random_member([Carac,Row,Col],ListWin),
	piece(PieceID,[Carac,_,_,_]),                          
	isEmpty(Board,Row,Col).

readPosition_clement(inline,Board,PieceID,Row,Col) :-

	get_list_win(Board,ListWin),
	random_member([Carac,Row,Col],ListWin),
	piece(PieceID,[_,Carac,_,_]),                          
	isEmpty(Board,Row,Col).	

readPosition_clement(inline,Board,PieceID,Row,Col) :-

	get_list_win(Board,ListWin),
	random_member([Carac,Row,Col],ListWin),
	piece(PieceID,[_,_,Carac,_]),                          
	isEmpty(Board,Row,Col).	
	
readPosition_clement(inline,Board,PieceID,Row,Col) :-

	get_list_win(Board,ListWin),
	random_member([Carac,Row,Col],ListWin),
	piece(PieceID,[_,_,_,Carac]),                          
	isEmpty(Board,Row,Col).		
	
readPosition_clement(inline,Board,_,Row,Col) :-
	readPosition_random(inline,Board,_,Row,Col).

get_list_win(Board,[Y]):-
	 findall(List,boardDiagonalWin(Board,List),Y).
	
/* findall(List,boardDiagonalWin([[1,0,0,10],[0,2,11,0],[0,0,3,0],[12,0,0,0]],List),Y). */
	

boardDiagonalWin([[W1,_,_,_],[_,X2,_,_],[_,_,Y3,_],[_,_,_,Z4]],[Carac,1,1]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[W1,_,_,_],[_,X2,_,_],[_,_,Y3,_],[_,_,_,Z4]],[Carac,2,2]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[W1,_,_,_],[_,X2,_,_],[_,_,Y3,_],[_,_,_,Z4]],[Carac,3,3]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[W1,_,_,_],[_,X2,_,_],[_,_,Y3,_],[_,_,_,Z4]],[Carac,4,4]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


boardDiagonalWin([[_,_,_,W1],[_,_,X2,_],[_,Y3,_,_],[Z4,_,_,_]],[Carac,1,4]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,W1],[_,_,X2,_],[_,Y3,_,_],[Z4,_,_,_]],[Carac,2,3]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,W1],[_,_,X2,_],[_,Y3,_,_],[Z4,_,_,_]],[Carac,3,2]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[_,_,_,W1],[_,_,X2,_],[_,Y3,_,_],[Z4,_,_,_]],[Carac,4,1]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


boardDiagonalWin([[W1,_,_,_],[X2,_,_,_],[Y3,_,_,_],[Z4,_,_,_]],[Carac,1,1]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[W1,_,_,_],[X2,_,_,_],[Y3,_,_,_],[Z4,_,_,_]],[Carac,2,1]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[W1,_,_,_],[X2,_,_,_],[Y3,_,_,_],[Z4,_,_,_]],[Carac,3,1]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[W1,_,_,_],[X2,_,_,_],[Y3,_,_,_],[Z4,_,_,_]],[Carac,4,1]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


boardDiagonalWin([[_,W1,_,_],[_,X2,_,_],[_,Y3,_,_],[_,Z4,_,_]],[Carac,1,2]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[_,W1,_,_],[_,X2,_,_],[_,Y3,_,_],[_,Z4,_,_]],[Carac,2,2]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[_,W1,_,_],[_,X2,_,_],[_,Y3,_,_],[_,Z4,_,_]],[Carac,3,2]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[_,W1,_,_],[_,X2,_,_],[_,Y3,_,_],[_,Z4,_,_]],[Carac,4,2]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


boardDiagonalWin([[_,_,W1,_],[_,_,X2,_],[_,_,Y3,_],[_,_,Z4,_]],[Carac,1,3]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[_,_,W1,_],[_,_,X2,_],[_,_,Y3,_],[_,_,Z4,_]],[Carac,2,3]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[_,_,W1,_],[_,_,X2,_],[_,_,Y3,_],[_,_,Z4,_]],[Carac,3,3]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[_,_,W1,_],[_,_,X2,_],[_,_,Y3,_],[_,_,Z4,_]],[Carac,4,3]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


boardDiagonalWin([[_,_,_,W1],[_,_,_,X2],[_,_,_,Y3],[_,_,_,Z4]],[Carac,1,4]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,W1],[_,_,_,X2],[_,_,_,Y3],[_,_,_,Z4]],[Carac,2,4]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,W1],[_,_,_,X2],[_,_,_,Y3],[_,_,_,Z4]],[Carac,3,4]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[_,_,_,W1],[_,_,_,X2],[_,_,_,Y3],[_,_,_,Z4]],[Carac,4,4]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).



boardDiagonalWin([[W1,X2,Y3,Z4],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[Carac,1,1]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[W1,X2,Y3,Z4],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[Carac,1,2]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[W1,X2,Y3,Z4],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[Carac,1,3]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[W1,X2,Y3,Z4],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[Carac,1,4]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


boardDiagonalWin([[_,_,_,_],[W1,X2,Y3,Z4],[_,_,_,_],[_,_,_,_]],[Carac,2,1]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[W1,X2,Y3,Z4],[_,_,_,_],[_,_,_,_]],[Carac,2,2]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[W1,X2,Y3,Z4],[_,_,_,_],[_,_,_,_]],[Carac,2,3]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[W1,X2,Y3,Z4],[_,_,_,_],[_,_,_,_]],[Carac,2,4]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


boardDiagonalWin([[_,_,_,_],[_,_,_,_],[W1,X2,Y3,Z4],[_,_,_,_]],[Carac,3,1]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[_,_,_,_],[W1,X2,Y3,Z4],[_,_,_,_]],[Carac,3,2]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[_,_,_,_],[W1,X2,Y3,Z4],[_,_,_,_]],[Carac,3,3]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[_,_,_,_],[W1,X2,Y3,Z4],[_,_,_,_]],[Carac,3,4]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


boardDiagonalWin([[_,_,_,_],[_,_,_,_],[_,_,_,_],[W1,X2,Y3,Z4]],[Carac,4,1]):- W1 is 0,common_charac([X2,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[_,_,_,_],[_,_,_,_],[W1,X2,Y3,Z4]],[Carac,4,2]):- X2 is 0,common_charac([W1,Y3,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[_,_,_,_],[_,_,_,_],[W1,X2,Y3,Z4]],[Carac,4,3]):- Y3 is 0,common_charac([W1,X2,Z4],Carac).
boardDiagonalWin([[_,_,_,_],[_,_,_,_],[_,_,_,_],[W1,X2,Y3,Z4]],[Carac,4,4]):- Z4 is 0,common_charac([W1,X2,Y3],Carac).


/*boardDiagonalWin([[W1,_,_,Z1],[_,X2,Y2,_],[_,X3,Y3,_],[W4,_,_,Z4]],[[W1,X2,Y3,Z4],[W4,X3,Y2,Z1]]).*/



common_charac([X1,X2,X3],Color):-piece(X1,[Color,_,_,_]),piece(X2,[Color,_,_,_]),piece(X3,[Color,_,_,_]),Color \= 'nul'.
common_charac([X1,X2,X3],Height):-piece(X1,[_,Height,_,_]),piece(X2,[_,Height,_,_]),piece(X3,[_,Height,_,_]),Height \= 'nul'.
common_charac([X1,X2,X3],Geometry):-piece(X1,[_,_,Geometry,_]),piece(X2,[_,_,Geometry,_]),piece(X3,[_,_,Geometry,_]),Geometry \= 'nul'.
common_charac([X1,X2,X3],Hole):-piece(X1,[_,_,_,Hole]),piece(X2,[_,_,_,Hole]),piece(X3,[_,_,_,Hole]),Hole \= 'nul'.
