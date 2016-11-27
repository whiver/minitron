% Serveur HTTP capable de traiter les requêtes de l'IHM %
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_parameters)).

server(Port) :-
        http_server(http_dispatch,
                    [port(Port)]),
        set_setting(http:cors, ['*']).

:- http_handler(root(start), httpStartHandler, []).
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
          P2AI).

getStartRequestParams(Request,
                      BoardSize,
                      P1X, P1Y,
                      P2X, P2Y,
                      P1AI,
                      P2AI) :-
    http_parameters(Request,
                    [boardSize(BoardSize, [nonneg]),
                     p1X(P1X, [between(1, BoardSize), default(1)]),
                     p1Y(P1Y, [between(1, BoardSize), default(P1X)]),
                     p2X(P2X, [between(1, BoardSize), default(BoardSize)]),
                     p2Y(P2Y, [between(1, BoardSize), default(P2X)]),
                     p1AI(P1AI, [oneof(['AI_RANDOM',
                                        'AI_RANDOM2',
                                        'AI_FOLLOWER'])]),
                     p2AI(P2AI, [oneof(['AI_RANDOM',
                                        'AI_RANDOM2',
                                        'AI_FOLLOWER'])])]).

:- http_handler(root(playOnce), httpPlayOnceHandler, []).
httpPlayOnceHandler(_) :-
    cors_enable,
    playOnce(State),
    sendGameState(State).

sendGameState(State) :-
    format('Content-type: application/json~n~n', []),
    format('{', []),
    format('"state":~w,', [State]),
    board(_, [P1X,P1Y], [P2X,P2Y]),
    format('"p1X":~w,', [P1X]),
    format('"p1Y":~w,', [P1Y]),
    format('"p2X":~w,', [P2X]),
    format('"p2Y":~w', [P2Y]),
    format('}', []).
