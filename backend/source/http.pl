% Serveur HTTP capable de traiter les requêtes de l'IHM %
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

server(Port) :-
        http_server(http_dispatch,
                    [port(Port)]).


% Méthode appelée sur l'URL '/initialBoardState'
% Retourne l'état initial du plateau (taille et position des têtes)
:- http_handler(root(initialBoardState), httpInitialBoardState, []).
httpInitialBoardState(_) :-
	format('Content-type: application/json~n~n', []),
	format('{', []),
	initialBoardToJSON,
	format('}', []).

% Méthode appelée sur l'URL '/nextBoardState'
% Joue une itération et retourne la nouvelle position des têtes
:- http_handler(root(nextBoardState), httpNextBoardState, []).
httpNextBoardState(_) :-
	format('Content-type: application/json~n~n', []),
	format('{', []),
	nextBoardToJSON,
	format('}', []).

% Retourne la taille d'un côté du board et les têtes des joueurs en JSON
initialBoardToJSON :-
	sizeToJSON,
	format(',', []),
	headsToJSON.

% Joue une itération et retourne la nouvelle position des têtes en JSON
% WARNING: Erreur si GameOver
nextBoardToJSON :-
	playStep,
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
