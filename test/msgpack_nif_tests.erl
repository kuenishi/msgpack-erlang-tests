%%
%% MessagePack for Erlang
%%
%% Copyright (C) 2009-2013 UENISHI Kota
%%
%%    Licensed under the Apache License, Version 2.0 (the "License");
%%    you may not use this file except in compliance with the License.
%%    You may obtain a copy of the License at
%%
%%        http://www.apache.org/licenses/LICENSE-2.0
%%
%%    Unless required by applicable law or agreed to in writing, software
%%    distributed under the License is distributed on an "AS IS" BASIS,
%%    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%    See the License for the specific language governing permissions and
%%    limitations under the License.
%%

-module(msgpack_nif_tests).

-include_lib("eunit/include/eunit.hrl").

msgpack_props_test_() ->
    {timeout,10000, ?_assertEqual([],proper:module(msgpack_props))}.

unpack_test_() ->
    [
     {"not binary",
      ?_assertEqual({error, {badarg, []}}, msgpack:unpack([], [{use_nif,true}]))},

     {"incomplete: null binary",
      ?_assertEqual({error, incomplete}, msgpack:unpack(<<>>, [{use_nif,true}]))},
     
     {"incomplete: unknown binary",
      ?_assertEqual({error, incomplete}, msgpack:unpack(<<16#DA>>, [{use_nif,true}]))}
    ].

array_test_()->
    [
        {"length 16",
            fun() ->
                    List = lists:seq(0, 16),
                    Binary = msgpack:pack(List, [{use_nif,true}]),
                    ?assertEqual({ok, List}, msgpack:unpack(Binary, [{use_nif,true}]))
            end},
        {"length 32",
            fun() ->
                    List = lists:seq(0, 16#010000),
                    Binary = msgpack:pack(List, [{use_nif,true}]),
                    ?assertEqual({ok, List}, msgpack:unpack(Binary, [{use_nif,true}]))
            end},
        {"empty",
            fun() ->
                    EmptyList = [],
                    Binary = msgpack:pack(EmptyList, [{use_nif,true}]),
                    ?assertEqual({ok, EmptyList}, msgpack:unpack(Binary, [{use_nif,true}]))
            end}
    ].


map_test_()->
    [
        {"length 16",
            fun() ->
                    Map = {[ {X, X * 2} || X <- lists:seq(0, 16) ]},
                    Binary = msgpack:pack(Map, [{use_nif,true}]),
                    ?assertEqual({ok, Map}, msgpack:unpack(Binary, [{use_nif,true}]))
            end},
        {"length 32",
            fun() ->
                    Map = {[ {X, X * 2} || X <- lists:seq(0, 16#010000) ]},
                    Binary = msgpack:pack(Map, [{use_nif,true}]),
                    ?assertEqual({ok, Map}, msgpack:unpack(Binary, [{use_nif,true}]))
            end},
        {"empty",
            fun() ->
                    EmptyMap = {[]},
                    Binary = msgpack:pack(EmptyMap, [{use_nif,true}]),
                    ?assertEqual({ok, EmptyMap}, msgpack:unpack(Binary, [{use_nif,true}]))
            end}
    ].

int_test_() ->
    [
        {"",
            fun() ->
                    Term = -2147483649,
                    Binary = msgpack:pack(Term, [{use_nif,true}]),
                    ?assertEqual({ok, Term}, msgpack:unpack(Binary, [{use_nif,true}]))
            end}
    ].

error_test_()->
    [
        {"badarg atom",
            ?_assertEqual({error, {badarg, atom}},
                          msgpack:pack(atom, [{use_nif,true}]))},
        {"badarg tuple",
            fun() ->
                    Term = {"hoge", "hage", atom},
                    ?assertEqual({error, {badarg, Term}},
                                 msgpack:pack(Term, [{use_nif,true}]))
            end}
    ].

binary_test_() ->
    [
        {"0 byte",
            fun() ->
                    Binary = msgpack:pack(<<>>, [{use_nif,true}]),
                    ?assertEqual({ok, <<>>}, msgpack:unpack(Binary, [{use_nif,true}]))
            end}
    ].

%% long_binary_test_()->
%%     [
%%         {"long binary",
%%             fun() ->
%%                     A = pack(1),
%%                     B = pack(10),
%%                     C = pack(100),
%%                     ?assertEqual({[1,10,100], <<>>},
%%                                  msgpack:unpack(list_to_binary([A, B, C])))
%%             end}
%%     ].
