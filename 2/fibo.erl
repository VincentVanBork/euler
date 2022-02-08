-module(fibo).
-export([main/0, fibo/1, fibo/0]).

fibo() ->
    fibo([2, 1]).

fibo(Accumulator) ->
    NextElem = lists:sum(lists:sublist(Accumulator, 2)),
    case NextElem < 4_000_000 of
        true -> fibo([NextElem | Accumulator]);
        false -> Accumulator
    end.

main() ->
    io:format("Hello World ~n"),
    Numbers = fibo(),
    Answer = lists:sum(lists:filter(fun(Num) -> (Num rem 2) =:= 0 end, Numbers)),
    io:format("length: ~w , and sum : ~w ~n", [length(Numbers), Answer]).
