create_row(N, Elem, Row) :-
    length(Row, N),
    maplist(=(Elem), Row).

create_matrix(N, Elem, Matrix) :-
    length(Matrix, N),
    maplist(create_row(N, Elem), Matrix).

init_matrix(Matrix) :-
    create_matrix(9, 2, Matrix).

element_at(Matrix, Row, Col, Element) :-
    nth1(Row, Matrix, MatrixRow),
    nth1(Col, MatrixRow, Element).

element_exists(Element, List) :-
    member(Element, List).

verify_in_row(Element, Matrix, Row) :-
    nth1(Row, Matrix, MatrixRow),
    element_exists(Element, MatrixRow).

verify_in_column(Element, Matrix, Col) :-
    transpose(Matrix, TransposedMatrix),
    nth1(Col, TransposedMatrix, Column),
    element_exists(Element, Column).

transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
    lists_firsts_rests(Ms, Ts, Ms1),
    transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
    lists_firsts_rests(Rest, Fs, Oss).

verify_in_quadrant(Matrix, X, Y, Element) :-
    QX is ((X - 1) // 3) * 3 + 1,
    QY is ((Y - 1) // 3) * 3 + 1,
    extract_quadrant(Matrix, QX, QY, Quadrant),
    element_exists(Element, Quadrant).

extract_quadrant(Matrix, QX, QY, Quadrant) :-
    QX2 is QX + 2,
    QY2 is QY + 2,
    findall(Element, (
        between(QX, QX2, Row),
        between(QY, QY2, Col),
        element_at(Matrix, Row, Col, Element)
    ), Quadrant).

:- initialization(main).

main :-
    % Inicializa a matriz 9x9
    init_matrix(Matrix),
    format('Matriz 9x9 vazia:~n~w~n', [Matrix]),

    % Acessa o elemento na posição (2, 3)
    element_at(Matrix, 2, 3, Element),
    format('Elemento na posição (2, 3): ~w~n', [Element]),

    (verify_in_row(0, Matrix, 2) -> format('Elemento 0 encontrado na linha 2~n') ; format('Elemento 0 não encontrado na linha 2~n')),

    (verify_in_column(0, Matrix, 3) -> format('Elemento 0 encontrado na coluna 3~n') ; format('Elemento 0 não encontrado na coluna 3~n')),

    (verify_in_quadrant(Matrix, 2, 3, 0) -> format('Elemento 0 encontrado no quadrante 3x3 contendo (2, 3)~n') ; format('Elemento 0 não encontrado no quadrante 3x3 contendo (2, 3)~n')),

    halt.
