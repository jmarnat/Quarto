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

askPiece(_,human,Board,PieceID,_) :-
	askPiece_human(inline,Board,PieceID).

askPiece(_,random,Board,PieceID,_) :-
	askPiece_random(inline,Board,PieceID).

askPiece(_,anthony,Board,PieceID,LastPieceId) :-
	askPiece_anthony(inline,Board,PieceID,LastPieceId).

askPiece(_,josselin,Board,PieceID,_LastPieceId) :-
	askPiece_josselin(inline,Board,PieceID).

askPiece(_,clement,Board,PieceID,LastPieceId) :-
	askPiece_clement(inline,Board,PieceID,LastPieceId).

askPiece(_,jeremie,Board,PieceID,_) :-
	askPiece_jeremie(inline,Board,PieceID).

readPosition(_,human,Board,PieceID,Row,Col) :-
	write('Piece to play : '),printPiece(PieceID),nl,
	readPosition_human(inline,Board,PieceID,Row,Col).

readPosition(_,random,Board,PieceID,Row,Col) :-
	readPosition_random(inline,Board,PieceID,Row,Col).

readPosition(_,anthony,Board,PieceID,Row,Col) :-
	readPosition_anthony(inline,Board,PieceID,Row,Col).

readPosition(_,josselin,Board,PieceID,Row,Col) :-
	readPosition_josselin(inline,Board,PieceID,Row,Col).

readPosition(_,clement,Board,PieceID,Row,Col) :-
	readPosition_clement(inline,Board,PieceID,Row,Col).

readPosition(_,jeremie,Board,PieceID,Row,Col) :-
	readPosition_jeremie(inline,Board,PieceID,Row,Col).
