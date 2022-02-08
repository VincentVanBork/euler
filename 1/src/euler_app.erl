%%%-------------------------------------------------------------------
%% @doc euler public API
%% @end
%%%-------------------------------------------------------------------

-module(euler_app).
-behaviour(application).

-export([start/2, stop/1, is_multiple/2]).

start(_StartType, _StartArgs) ->
    euler_sup:start_link(),
    io:fwrite("hello, world\n"),
    fprof:trace(start),
    ThisProcess = self(),
    % io:format("THIS IS recevier: ~w ~n", [ThisProcess]),
    Workers = [
        spawn(euler_app, is_multiple, [Num, ThisProcess])
     || Num <- lists:seq(0, 1000)
    ],
    MultiplesList = [
        receive
            {sum, Value} ->
                % io:format("Recevide ~w ~n", [Value]),
                Value
        end
     || _ <- Workers
    ],
    % print_list(MultiplesList),
    MultiplesSum = lists:sum(MultiplesList),
    fprof:trace(stop),
    fprof:profile(),
    fprof:analyse({dest, "prfoile4.txt"}),
    io:format("THIS IS SUM: ~w ~n", [MultiplesSum]),
    io:get_line("Press Enter: \n").

print_list([]) ->
    io:format("~n", []),
    [];
print_list([H | T]) ->
    io:format("~w, ", [H]),
    [H | print_list(T)].

is_multiple(Number, SumReceiver) ->
    DividedBy3 = Number rem 3,
    DividedBy5 = Number rem 5,
    % io:format("from inside recevier: ~w ~n", [SumReceiver]),
    if
        DividedBy3 == 0 ->
            % io:format("found match ~w ~n", [Number]),
            SumReceiver ! {sum, Number};
        DividedBy5 == 0 ->
            % io:format("found match ~w ~n", [Number]),
            SumReceiver ! {sum, Number};
        true ->
            % io:format("did not match ~w ~n", [Number]),
            SumReceiver ! {sum, 0}
    end.

stop(_State) ->
    ok.

% internal functions
