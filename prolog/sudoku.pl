%list comes in as:
%[ [ 1-9 ]  ...
%  [ 1-9 ]  ...
%          ]
% board([ [5,3,0,0,7,0,0,0,0],
%         [6,0,0,1,9,5,0,0,0],
%         [0,9,8,0,0,0,0,6,0],
%         [8,0,0,0,6,0,0,0,3],
%         [4,0,0,8,0,3,0,0,1],
%         [7,0,0,0,2,0,0,0,6],
%         [0,6,0,0,0,0,2,8,0],
%         [0,0,0,4,1,9,0,0,5],
%         [0,0,0,0,8,0,0,7,9] ]).

% board([ [5,3,0,0,7,0,0,0,0],
%         [6,0,0,1,9,5,0,0,0],
%         [3,9,8,0,0,0,0,6,0],
%         [8,0,0,0,6,0,0,0,3],
%         [4,0,0,8,0,3,0,0,1],
%         [7,0,0,0,2,0,0,0,6],
%         [1,6,0,0,0,0,2,8,0],
%         [9,0,0,4,1,9,0,0,5],
%         [2,0,0,0,8,0,0,7,9] ]).

board([ [5,3,1,0,7,0,0,0,0],
        [6,4,2,1,9,5,0,0,0],
        [8,9,7,0,0,0,0,6,0],
        [8,0,0,0,6,0,0,0,3],
        [4,0,0,8,0,3,0,0,1],
        [7,0,0,0,2,0,0,0,6],
        [1,6,0,0,0,0,2,8,0],
        [9,0,0,4,1,9,0,0,5],
        [2,0,0,0,8,0,0,7,9] ]).

% X = 2 + 3 -> X: 2+3
% X is 2 + 3 -> X: 5
% X ==

%TODO
% e

print(X) :- board(X), show(X).

show([]) :- false.
show([R|Remaining]) :-  write(R), write('\n'), show(Remaining).

getIthItem([H|_], 0, H).
getIthItem([_|T], I, Return) :- J is I - 1, getIthItem(T, J, Return).

noDouble(Lst) :- noDoubleHelper(Lst, [0]).
noDoubleHelper([],_).
noDoubleHelper([H|T], Seen) :-
    not(memberIgnore0(H, Seen)), append(Seen, [H], UpdatedSeen), noDoubleHelper(T, UpdatedSeen).

%works like member(X,Lst), but ignores 0
memberIgnore0(X, Lst) :- 
    not(X==0), 
    member(X, Lst).


%% stuff below this needs to be redone
checkRow(R) :-   
                member(1, R), 
                member(2, R),
                member(3, R),
                member(4, R),
                member(5, R),
                member(6, R),
                member(7, R),
                member(8, R),
                member(9, R).



%Index is between 0 and 8
checkCol([R1, R2, R3, R4, R5, R6, R7, R8, R9], Index) :- getIthItem(R1, Index, X1), 
                                                         getIthItem(R2, Index, X2), 
                                                         getIthItem(R3, Index, X3), 
                                                         getIthItem(R4, Index, X4), 
                                                         getIthItem(R5, Index, X5), 
                                                         getIthItem(R6, Index, X6), 
                                                         getIthItem(R7, Index, X7), 
                                                         getIthItem(R8, Index, X8), 
                                                         getIthItem(R9, Index, X9),
                                                         checkRow([X1, X2, X3, X4, X5, X6, X7, X8, X9]).
%I and J are between 0 and 2
checkBox(B, I, J) :- V1 is J*3, V2 is J*3+1, V3 is J*3+2,
                     V is I*3, 
                     getIthItem(B, V, R1), getIthItem(R1, V1, X1), getIthItem(R1, V2, X2), getIthItem(R1, V3, X3),
                     X is I*3+1, 
                     getIthItem(B, X, R2), getIthItem(R2, V1, X4), getIthItem(R2, V2, X5), getIthItem(R2, V3, X6),
                     Y is I*3+2, 
                     getIthItem(B, Y, R3), getIthItem(R3, V1, X7), getIthItem(R3, V2, X8), getIthItem(R3, V3, X9),
                     check([X1, X2, X3, X4, X5, X6, X7, X8, X9]).

checkAllRow(B) :- 
                getIthItem(B,0,R0), checkRow(R0),
                getIthItem(B,1,R1), checkRow(R1),
                getIthItem(B,2,R2), checkRow(R2),
                getIthItem(B,3,R3), checkRow(R3),
                getIthItem(B,4,R4), checkRow(R4),
                getIthItem(B,5,R5), checkRow(R5),
                getIthItem(B,6,R6), checkRow(R6),
                getIthItem(B,7,R7), checkRow(R7),
                getIthItem(B,8,R8), checkRow(R8).

checkAllCol([R0, R1, R2, R3, R4, R5, R6, R7, R8]) :- 
                checkCol(R0, 0),
                checkCol(R1, 1),
                checkCol(R2, 2),
                checkCol(R3, 3),
                checkCol(R4, 4),
                checkCol(R5, 5),
                checkCol(R6, 6),
                checkCol(R7, 7),
                checkCol(R8, 8).




checkAllBox(B) :-
    checkBox(B,0,0),
    checkBox(B,0,1),
    checkBox(B,0,2),
    checkBox(B,1,0),
    checkBox(B,1,1),
    checkBox(B,1,2),
    checkBox(B,2,0),
    checkBox(B,2,1),
    checkBox(B,2,2).

%
% solve(B, S) :- 

startSolve(X) :- board(X), solve(X, Y), show(Y).