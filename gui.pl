/*:- new(Window,picture('Hello World')),
    send(Window,display,text('Welcome in Quarto!'),point(20,20)),
    send(button(hello, message(@prolog, format, ’Hi There ’)), open),
    send(Window,open).
*/

askPiece(PieceID) :-
    new(Dialog,dialog('Choose a piece to give')),
    send_list(Dialog,append,[
            new(N1,text_item())
              ])
