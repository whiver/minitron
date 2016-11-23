
% Serveur HTTP capable de traiter les requêtes de l'IHM %
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

server(Port) :-
        http_server(http_dispatch,
                    [port(Port)]).

:- http_handler(root(initialBoardState), httpInitialBoardState, []).

% Formate le board en JSON
% Ne retourne que la taille d'un côté et les têtes des joueurs
initialBoardToJSON :-
	sizeToJSON,
	format(',', []),
	headsToJSON.

% Formate la taille d'un côté du board en JSON
sizeToJSON :-
	dim(Size),
	format('"size":~w', [Size]).

% Formate les têtes des joueurs en JSON
headsToJSON :-
	format('"heads":[', []),
	board(_, H1, H2),
	headToJSON(H1),
	format(',', []),
	headToJSON(H2),
	format(']', []).

% Formate une tête d'un joueur en JSON
headToJSON([H|[T|_]]) :- format('{"x":~w,"y":~w}', [H, T]).

% Méthode appelée sur l'URL '/initialBoardState'
httpInitialBoardState(_) :-
	format('Content-type: application/json~n~n', []),
	format('{', []),
	initialBoardToJSON,
	format('}', []).