% Serveur HTTP capable de traiter les requêtes de l'IHM %
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_parameters)).

% Instancie un serveur HTTP qui écoute au port spécifié
% Port -> port sur lequel le serveur HTTP va écouter
server(Port) :-
        http_server(http_dispatch,
                    [port(Port)]),
        set_setting(http:cors, ['*']).

:- http_handler(root(start), httpStartHandler, []).
% Handler répondant à l'URL /start
% Démarre la partie à partir des paramètres passés avec la requête
% Request -> Requête HTTP de démarrage de la partie
httpStartHandler(Request) :-
    cors_enable,
    getStartRequestParams(Request,
                          BoardSize,
                          P1X, P1Y,
                          P2X, P2Y,
                          P1AI,
                          P2AI),
    start(BoardSize,
          [P1X, P1Y],
          [P2X, P2Y],
          P1AI,
          P2AI),
    format('Status: 204 No Content~n~n', []).

% Récupère les paramètres associés à la requête de démarrage de la partie
% Request -> Requête HTTP de démarrage de la partie
% BoardSize -> Taille d'un côté du plateau
% P1X -> Position en X du joueur 1 
% P1Y -> Position en Y du joueur 1
% P2X -> Position en X du joueur 2
% P2Y -> Position en Y du joueur 2
% P1AI -> IA du joueur 1 (ex: AI_RANDOM2)
% P2AI -> IA du joueur 2 (ex: AI_FOLLOWER)
getStartRequestParams(Request,
                      BoardSize,
                      P1X, P1Y,
                      P2X, P2Y,
                      P1AI,
                      P2AI) :-
    http_parameters(Request,
                    [boardSize(BoardSize, [nonneg]),
                     p1X(P1X, [between(1, BoardSize), default(1)]),
                     p1Y(P1Y, [between(1, BoardSize), default(1)]),
                     p2X(P2X, [between(1, BoardSize), default(BoardSize)]),
                     p2Y(P2Y, [between(1, BoardSize), default(BoardSize)]),
                     p1AI(P1AI, [oneof(['AI_RANDOM',
                                        'AI_RANDOM2',
                                        'AI_FOLLOWER'])]),
                     p2AI(P2AI, [oneof(['AI_RANDOM',
                                        'AI_RANDOM2',
                                        'AI_FOLLOWER'])])]).

:- http_handler(root(playOnce), httpPlayOnceHandler, []).
% Handler répondant à l'URL /playOnce
% Joue une itération du jeu et retourner l'état résultant de la partie
httpPlayOnceHandler(_) :-
    cors_enable,
    playOnce(State),
    sendGameState(State).

% Créer une réponse JSON décrivant l'état courant de la partie (état, positions des joueurs)
% State -> État courant de la partie
sendGameState(State) :-
    format('Content-type: application/json~n~n', []),
    format('{', []),
    format('"state":"~w",', [State]),
    board(_, [P1X,P1Y], [P2X,P2Y]),
    format('"p1X":~w,', [P1X]),
    format('"p1Y":~w,', [P1Y]),
    format('"p2X":~w,', [P2X]),
    format('"p2Y":~w', [P2Y]),
    format('}', []).
