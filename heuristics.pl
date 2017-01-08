/* heuristics.pl */
/* everyone */

library(random).

/* CONSULTING HEURISTICS FILES */
:- consult('heuristics/human.pl').
:- consult('heuristics/random.pl').
:- consult('heuristics/anthony.pl').
:- consult('heuristics/clement.pl').
:- consult('heuristics/josselin.pl').
:- consult('heuristics/jeremie.pl').


getHeuristics([Heuristics1,_],1,Heuristics1).
getHeuristics([_,Heuristics2],2,Heuristics2).

heuristics(human).
heuristics(anthony).
heuristics(random).
heuristics(clement).
heuristics(josselin).
heuristics(jeremie).
%% heuristics().



/* remapping all the askPiece and readPosition functions */
/* because Prolog don't like separated clauses definitions */
/* "Clauses of askPiece/5 are not together in the source-file" */

askPiece(inline,human,Board,PieceID,_) :-
	askPiece_human(inline,Board,PieceID).

askPiece(inline,random,Board,PieceID,_) :-
	askPiece_random(inline,Board,PieceID).

askPiece(inline,anthony,Board,PieceID,LastPieceId) :-
	askPiece_anthony(inline,Board,PieceID,LastPieceId).

askPiece(inline,josselin,Board,PieceID,_LastPieceId) :-
	askPiece_josselin(inline,Board,PieceID).

askPiece(inline,clement,Board,PieceID,LastPieceId) :-
	askPiece_clement(inline,Board,PieceID,LastPieceId).

askPiece(inline,jeremie,Board,PieceID,_) :-
	askPiece_jeremie(inline,Board,PieceID).

readPosition(inline,human,Board,PieceID,Row,Col) :-
	write('Piece to play : '),printPiece(PieceID),nl,
	readPosition_human(inline,Board,PieceID,Row,Col).

readPosition(inline,random,Board,PieceID,Row,Col) :-
	readPosition_random(inline,Board,PieceID,Row,Col).

readPosition(inline,anthony,Board,PieceID,Row,Col) :-
	readPosition_anthony(inline,Board,PieceID,Row,Col).

readPosition(inline,josselin,Board,PieceID,Row,Col) :-
	readPosition_josselin(inline,Board,PieceID,Row,Col).

readPosition(inline,clement,Board,PieceID,Row,Col) :-
	readPosition_clement(inline,Board,PieceID,Row,Col).

readPosition(inline,jeremie,Board,PieceID,Row,Col) :-
	readPosition_jeremie(inline,Board,PieceID,Row,Col).
