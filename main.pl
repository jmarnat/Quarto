/*
- add your consults above
- write this two functions :
	askPiece(inline,<yourheuristics>,Board,PieceID)
	readPosition(inline,<yourheuristics>,Board,PieceID,Row,Column)

*/



/* CONSULTING BASE FILES */
:- consult('quarto.pl').
:- consult('inline_interface.pl').
:- consult('heuristics.pl').

:- write('FILES LOADED !'),nl,nl.
:- write('\e[035mtype : "play(inline,human,random)" to begin\e[0m'),nl,nl.
