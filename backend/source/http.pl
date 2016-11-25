% Serveur HTTP capable de traiter les requêtes de l'IHM %
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_cors)).

server(Port) :-
        http_server(http_dispatch,
                    [port(Port)]),
        set_setting(http:cors, ['*']).


% Méthode appelée sur l'URL '/initialBoardState'
% Retourne l'état initial du plateau (taille et position des têtes)
:- http_handler(root(initialBoardState), httpInitialBoardState, []).
httpInitialBoardState(_) :-
	cors_enable,
	format('Content-type: application/json~n~n', []),
	format('{', []),
	initialBoardToJSON,
	format('}', []).

% Méthode appelée sur l'URL '/nextBoardState'
% Joue une itération et retourne la nouvelle position des têtes
:- http_handler(root(nextBoardState), httpNextBoardState, []).
httpNextBoardState(_) :-
	cors_enable,
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
	statusToJSON,
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

% Formate le statut de la partie (match nul, victoire J2, etc.) en JSON
% 0  : match en cours
% -1 : match nul
% 1  : victoire joueur 1
% 2  : victoire joueur 2
statusToJSON :-
	format('"status":0').
