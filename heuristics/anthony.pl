/* anthony.pl */

invertAttribute(white,black).
invertAttribute(black,white).
invertAttribute(short,long).
invertAttribute(long,short).
invertAttribute(round,square).
invertAttribute(square,round).
invertAttribute(hole,flat).
invertAttribute(flat,hole).


printAPiece(PieceID):-
write(PieceID),write(' ('),printPiece(PieceID),write(')'),nl.

countPieces(16,[]):-!.
countPieces(Nu,[H|T]):-
	countEmpty(NE,H),	
	countPieces(N,T),
	Nu is N-NE.
countEmpty(NE,[0|T]):-
	countEmpty(NET,T),
	NE is NET+1.
countEmpty(NE,[_|T]):-
	countEmpty(NE,T).
countEmpty(0,[]).

%% searching for the invert piece of the first
invertPiece(PieceID,InvertID):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IVColor),
	invertAttribute(Height,IVHeight),
	invertAttribute(Geometry,IVGeometry),
	invertAttribute(Hole,IVHole),
	piece(InvertID,[IVColor,IVHeight,IVGeometry,IVHole]).

%% search'N' predicate, searching for a list of pieces with sharing N Attributes
share3(PieceID,[P1,P2,P3,P4]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IVColor),
	invertAttribute(Height,IVHeight),
	invertAttribute(Geometry,IVGeometry),
	invertAttribute(Hole,IVHole),
	piece(P1,[Color,Height,Geometry,IVHole]),
	piece(P2,[Color,Height,IVGeometry,Hole]),
	piece(P3,[Color,IVHeight,Geometry,Hole]),
	piece(P4,[IVColor,Height,Geometry,Hole]).
share1(PieceID,[P1,P2,P3,P4]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IVColor),
	invertAttribute(Height,IVHeight),
	invertAttribute(Geometry,IVGeometry),
	invertAttribute(Hole,IVHole),
	piece(P1,[IVColor,IVHeight,IVGeometry,Hole]),
	piece(P2,[IVColor,IVHeight,Geometry,IVHole]),
	piece(P3,[IVColor,Height,IVGeometry,IVHole]),
	piece(P4,[Color,IVHeight,IVGeometry,IVHole]).
share2(PieceID,[P1,P2,P3,P4,P5,P6]):-
	piece(PieceID,[Color,Height,Geometry,Hole]),
	invertAttribute(Color,IVColor),
	invertAttribute(Height,IVHeight),
	invertAttribute(Geometry,IVGeometry),
	invertAttribute(Hole,IVHole),
	piece(P1,[Color,Height,IVGeometry,IVHole]),
	piece(P2,[Color,IVHeight,Geometry,IVHole]),
	piece(P3,[Color,IVHeight,IVGeometry,Hole]),
	piece(P4,[IVColor,Height,Geometry,IVHole]),
	piece(P5,[IVColor,Height,IVGeometry,Hole]),
	piece(P6,[IVColor,IVHeight,Geometry,Hole]).


%% get a list of pieces that are not loosing at the current state of the Board
getNonLoosesPieces(Board,PiecesList):-
	getLoosesPieces(Board,LoosePieces),
	getAvailablePieces(Board,PossiblePieces),
	subtract(PossiblePieces,LoosePieces,PiecesList),!
.
%% get list of loosing pieces at the Board state
getLoosesPieces(Board,ListOfPieces):-
	getAvailablePieces(Board,AvailablePieces),
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).

getLoosesPiecesBis(_,[],[]).
getLoosesPiecesBis(Board,[PieceID|ListOfPieces],[PieceID|AvailablePieces]) :-
	checkWinPosition(Board,PieceID,_,_),
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).
getLoosesPiecesBis(Board,ListOfPieces,[_|AvailablePieces]) :-
	getLoosesPiecesBis(Board,ListOfPieces,AvailablePieces).

%% check if at the Board State PieceID win at [Row,Col]
checkWinPosition(Board,PieceID,Row,Col):-
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	check_win(NewBoard,_,_,_),!.


printRC(R,C):-write('['),write(R),write(','),write(C),write(']'),nl.
printGameState(Board):-
	getNonLoosesPieces(Board,NLP),
	printRC('NonLoosesPieces',NLP),
	getLoosesPieces(Board,LP),
	printRC('LoosesPieces',LP),
	getAvailablePieces(Board,AP),
	printRC('AvailablePieces',AP).



/*Choosing Piece To give */
askPiece_anthony(inline,Board,PieceID,MyPieceID):-
	countPieces(N,Board),
	getLoosesPieces(Board,LoosePieces),
	getAvailablePieces(Board,PossiblePieces),
	subtract(PossiblePieces,LoosePieces,PiecesList),
	choosePiece(Board,N,MyPieceID,PieceID,PiecesList,LoosePieces),
	%% write('LoosePieces:'),write(LoosePieces),nl,
	%% write('PossiblePieces:'),write(PossiblePieces),nl,
	%% write('PiecesList:'),write(PiecesList),nl,
	%% write('I choose :'),printAPiece(PieceID),
	!.

%% choose a piece with the predicate givePiece
choosePiece(_,N,MyPieceID,PieceID,PiecesList,LoosePieces):-
	givePiece(N,MyPieceID,PieceID,PiecesList,LoosePieces)
.
%% choose a random Piece if givePiece failed
choosePiece(Board,_,_,PieceID,_,_):-
	getAvailablePieces(Board,AvailablePieces),
	write('random choose:'), nl,
	randomPiece(PieceID,AvailablePieces).
%% choose a Piece for the first turn
givePiece(0,_,PieceID,AvailablePieces,_):-
	randomPiece(PieceID,AvailablePieces)	
.

%% search a Piece to give and check if the piece a good is playable
givePiece(N,MyPieceID,PieceID,AvailablePieces,LoosePieces):-
	findPiece(N,MyPieceID,PieceID),
	checkPiece(PieceID,AvailablePieces,LoosePieces).
%% if any piece are good enough give piece choose randomly in a not loosing pieces list
givePiece(_,_,PieceID,AvailablePieces,LoosePieces):-
	randomPiece(PieceID,AvailablePieces),
	\+memberchk(PieceID,LoosePieces)
.

%% check the piece
checkPiece(PieceID,AvailablePieces,LoosePieces):-
	memberchk(PieceID,AvailablePieces),
	\+memberchk(PieceID,LoosePieces).

%% findPiece searching for a Piece with few Attributes in common for 5 first turn and after choose with most Attributes in common
%% before the 5th turn
findPiece(N,MyPieceID,PieceID):-
	N>0,N<5,
	invertPiece(MyPieceID,PieceID).

%% find 1 share
findPiece(N,MyPieceID,PieceID):-
	N>0,N<5,
	share1(MyPieceID,PiecesList),
	memberchk(PieceID,PiecesList).

%% find 2 share
findPiece(N,MyPieceID,PieceID):-
	N>0,N<5,
	share2(MyPieceID,PiecesList),
	memberchk(PieceID,PiecesList).

%% from 5th turn
%% find 3 share
findPiece(N,MyPieceID,PieceID):-
	N>4,
	share3(MyPieceID,PiecesList),
	memberchk(PieceID,PiecesList).
%% find 2 share
findPiece(N,MyPieceID,PieceID):-
	N>4,
	share2(MyPieceID,PiecesList),
	memberchk(PieceID,PiecesList).

%% find 1 share
findPiece(N,MyPieceID,PieceID):-
	N>4,
	share1(MyPieceID,PiecesList),
	memberchk(PieceID,PiecesList).

%% find random
randomPiece(RandomPiece,AvailablePieces):-
	random_member(RandomPiece,AvailablePieces),!.

/* Choosing better Place For my Piece */




%% Searching for a wining position
readPosition_anthony(inline,Board,PieceID,Row,Col):-
	checkWinPosition(Board,PieceID,Row,Col),!.

readPosition_anthony(inline,Board,PieceID,Row,Col):-

	choosePosition(Board,PieceID,Row,Col),
	isEmpty(Board,Row,Col),!.

%% check a Position if the AI can loose next turn
goodMove(_,0,_,_).
goodMove(Board,PieceID,Row,Col):-
	isEmpty(Board,Row,Col),
	putPieceOnBoard(PieceID,Row,Col,Board,NewBoard),
	getAvailablePieces(NewBoard,AP),
	\+getLoosesPieces(NewBoard,AP),!.

%% searching for a position
choosePosition(Board,PieceID,Row,Col):-
	printAPiece(PieceID),
	countPieces(N,Board),
	findPosition(N,Board,PieceID,Row,Col).

%% searching for a position 
%% first checking of the turn with N
findPosition(N,Board,_,Row,Col):-
	N<5,N>0, /*searching for a position with no pieces in alignement*/
	optimalPos(4,Board,0,Row,Col). /*search a position with 4 pieces sahres attributes in common with 0*/

findPosition(N,Board,PieceID,Row,Col):-
	N>12,
	findDefensePosition(Board,PieceID,Row,Col).

findPosition(N,Board,PieceID,Row,Col):-
	N>5,
	optimalPos(2,Board,PieceID,Row,Col). /*find a position share an attribute with 2 pieces*/

findPosition(N,Board,PieceID,Row,Col):-
	N>5,
	optimalPos(1,Board,PieceID,Row,Col). /*find a position share an attribute with 1 pieces*/

findPosition(N,Board,PieceID,Row,Col):-
	N>5,N<11,
	findDefensePosition(Board,PieceID,Row,Col).

%% if any position was founded so the ai searching for an random position
%% probably loosing position
findPosition(_,Board,_,Row,Col):-
	isEmpty(Board,Row,Col),
	random_member(Row,[2,3,1,4]),
	random_member(Col,[2,3,1,4]).

%% if the AI is in bad state we just have to play in a possible opponent wining position
findDefensePosition(Board,PieceID,Row,Col):-
	getLoosesPieces(Board,LoosePieces),
	random_member(AvailablePiece,LoosePieces),
	checkWinPosition(Board,AvailablePiece,Row,Col),
	goodMove(Board,PieceID,Row,Col).

%%  optimalPos searching for N attributes in common in line, column or diagonal 
checkDiag(N1,Board,Row,Col,Attributes):-
	memberchk(DAttribute,Attributes),
	boardDiagonal(Board,BoardDiagonal),
	random_member(DiagPos,[3,1,4,2]),
	selectListPiece(Diag,BoardDiagonal,SelectedDia),
	searchNAttribute(N1,SelectedDia,DAttribute),
	diagRowCol(Diag,DiagPos,Row,Col).

checkDiag(_,_,Row,Col,_):-
	\+diagRowCol(_,_,Row,Col).

%% search exactly N times an Attribute in a list of piece 
searchNAttribute(N,[],_):-
	N is 0.

%% searching for attribute with no pieces used for having no pieces in same line with an other
searchNAttribute(N,[0|RestOfPieces],nul):-
	searchNAttribute(Nr,RestOfPieces,nul),
	N is Nr+1.

searchNAttribute(N,[PieceID|RestOfPieces],Attribute):-
	searchAttribute(PieceID,Attribute),
	searchNAttribute(Nr,RestOfPieces,Attribute),
	N is Nr+1.

searchNAttribute(N,[_|RestOfPieces],Attribute):-
	searchNAttribute(N,RestOfPieces,Attribute).

%% search an attribute in a piece
searchAttribute(PieceID,Attribute):-
	piece(PieceID,Attributes),
	memberchk(Attribute,Attributes).

%% selectListPiece select a list in the Board List of Row
selectListPiece(1,[X|_],X).
selectListPiece(2,[_|[X|_]],X).
selectListPiece(3,[_,_,X,_],X).
selectListPiece(4,[_,_,_,X],X).
diagRowCol(1,DiagPos,DiagPos,DiagPos).
diagRowCol(2,DiagPos,DiagPos,DiagPos2):-
	DiagPos2 is 5-DiagPos.
boardDiagonal([[W1,_,_,Z1],[_,X2,Y2,_],[_,X3,Y3,_],[W4,_,_,Z4]],[[W1,X2,Y3,Z4],[W4,X3,Y2,Z1]]).

boardRowToCol([[W1,X1,Y1,Z1],[W2,X2,Y2,Z2],[W3,X3,Y3,Z3],[W4,X4,Y4,Z4]],[[W1,W2,W3,W4],[X1,X2,X3,X4],[Y1,Y2,Y3,Y4],[Z1,Z2,Z3,Z4]]).

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(N,N,N,Board,PieceID,Row,Col).

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(N,_,_,Board,PieceID,Row,Col).

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(_,N,_,Board,PieceID,Row,Col).

optimalPos(N,Board,PieceID,Row,Col):-
	optimalPos(_,_,N,Board,PieceID,Row,Col).
optimalPos(N1,N2,N3,Board,PieceID,Row,Col):-
	piece(PieceID,Attributes),
	memberchk(RAttribute,Attributes),
	selectListPiece(Row,Board,SelectedRow),
	searchNAttribute(N1,SelectedRow,RAttribute),
	memberchk(CAttribute,Attributes),
	boardRowToCol(Board,ColBoard),
	selectListPiece(Col,ColBoard,SelectedCol),
	searchNAttribute(N2,SelectedCol,CAttribute),

	checkDiag(N3,Board,Row,Col,Attributes),
	goodMove(Board,PieceID,Row,Col).
