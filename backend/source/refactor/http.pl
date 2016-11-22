
% Serveur HTTP capable de traiter les requêtes de l'IHM %
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

server(Port) :-
        http_server(http_dispatch,
                    [ port(Port) ]).

:- http_handler(root(boardState), httpBoardState, []).

% Convertit le board en JSON
boardToJSON :-
	board(Board, H1, H2),
	format('"board":[', []),
	boardElemToJSON(Board), 
	format(']', []),
	format(',"heads":[', []),
	headToJSON(H1),
	format(',', []),
	headToJSON(H2),
	format(']', []).

% Convertit un élément du board en JSON et convertit le suivant
boardElemToJSON([]).
boardElemToJSON([H|T]) :- format('~w,', [H]), boardElemToJSON(T).

headToJSON([H|[T|_]]) :- format('{"x":~w,"y":~w}', [H, T]).

httpBoardState(_) :-
	format('Content-type: application/json~n~n', []),
	format('{', []),
	boardToJSON,
	format('}', []).