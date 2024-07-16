% server.pl
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).

:- use_module(main).

:- http_handler(root(start), solve_sudoku_handler, []).
:- http_handler(root(solve), solve_sudoku_handler, []).

server(Port) :-
    http_server(http_dispatch, [port(Port)])
    halt.

solve_sudoku_handler(Request) :-
    http_read_json_dict(Request, DictIn),
    main:solve_sudoku(DictIn.board, Solution),
    reply_json_dict(_{solution: Solution}).

:- initialization(server(8080)).