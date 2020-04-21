/* 
 * Sudoku solver made by Justin T Washington and Dawson d'Almeida 
 * list comes in as:
 * [ 
 *   [ 1-9 ]
 *   [ 1-9 ]
 *    ...x9
 *           ]
*/

% board([ %Finished Board
%         [5,3,4,6,7,8,9,1,2],
%         [6,7,2,1,9,5,3,4,8],
%         [1,9,8,3,4,2,5,6,7],
%         [8,5,9,7,6,1,4,2,3],
%         [4,2,6,8,5,3,7,9,1],
%         [7,1,3,9,2,4,8,5,6],
%         [9,6,1,5,3,7,2,8,4],
%         [2,8,7,4,1,9,6,3,5],
%         [3,4,5,2,8,6,1,7,9]
%     ]).

% board([ %Incomplete Board
%         [5,3,0,0,7,0,0,0,0],
%         [6,0,0,1,9,5,0,0,0],
%         [0,9,8,0,0,0,0,6,0],
%         [8,0,0,0,6,0,0,0,3],
%         [4,0,0,8,0,3,0,0,1],
%         [7,0,0,0,2,0,0,0,6],
%         [0,6,0,0,0,0,2,8,0],
%         [0,0,0,4,1,9,0,0,5],
%         [0,0,0,0,8,0,0,7,9] ]).

 board([ %Blank Board
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0]
         ]).


/* Show the board */
print(B) :- show(B).
show([]).
show([R|Remaining]) :-  write(R), write('\n'), show(Remaining).

/* Used for detecting valid numbers to place; no row, col, or box can have 2 of the same number */
noDouble(Lst) :- noDoubleHelper(Lst, [0]).
noDoubleHelper([],_).
noDoubleHelper([H|T], Seen) :-
    not(memberIgnore0(H, Seen)), append(Seen, [H], UpdatedSeen), noDoubleHelper(T, UpdatedSeen).
%works like member(X,Lst), but returns false on 0
memberIgnore0(X, Lst) :- 
    not(X==0), 
    member(X, Lst).

/* Given a Board, replace the next 0 with a valid number 1-9 and return it in NewBoard */
replace0(B, NewB) :- 
    getFirstRowWith0FromBoard(B,Row), %get the row to do the swap on
    nth0(ColIndex,Row,0), %Get ColIndex of 0 we replaced in OldRow
    nth0(RowIndexOld,B,Row), !, 
    swap0InRow(Row, NewRow),
    swapRowInBoard(Row, B, NewRow, NewB),
    nth0(RowIndexNew,NewB,NewRow), %Verify the correct indicies have been swapped
    RowIndexOld == RowIndexNew,
    checkSquare(NewB, RowIndexNew, ColIndex). %Verify valid placement.

/* Detect the first Row that has a 0 that can be replaced and return the Row */
getFirstRowWith0FromBoard([H|_], H) :- member(0, H), !.
getFirstRowWith0FromBoard([_|T], X) :- getFirstRowWith0FromBoard(T, X),!.
getFirstRowWith0FromBoard([],_) :- false. %when the board is out of rows to check for 0.

/* Given a Row with a 0, return that Row but with the first 0 swapped out for a number 1-9 */
swap0InRow([H|T],[X|T]) :- H is 0, !, between(1,9,X).
swap0InRow([H|T],[H|X]) :- swap0InRow(T, X). 

/* Swap out first matching OldRow in B with NewRow and return it in NewB */
swapRowInBoard(OldRow, [H|T], NewRow, [NewRow|T]) :- OldRow == H, !.
swapRowInBoard(OldRow, [H|T], NewRow, [H|X]) :- swapRowInBoard(OldRow, T, NewRow, X), !.

/* Verify that the row, col, and box of the square at (Row, Col) is valid */
checkSquare(B,Row,Col) :- 
    checkRow(B, Row),
    checkCol(B, Col),
    checkBox(B, Row, Col).

checkRow(B, Index) :-  
    nth0(Index,B,R),
    noDouble(R). 

checkCol([R0, R1, R2, R3, R4, R5, R6, R7, R8], Index) :- 
    nth0(Index, R0, X0),
    nth0(Index, R1, X1), 
    nth0(Index, R2, X2), 
    nth0(Index, R3, X3), 
    nth0(Index, R4, X4), 
    nth0(Index, R5, X5), 
    nth0(Index, R6, X6), 
    nth0(Index, R7, X7), 
    nth0(Index, R8, X8), 
    noDouble([X0, X1, X2, X3, X4, X5, X6, X7, X8]).

checkBox(B, Row, Col) :- 
    ARowIndex is (Row//3)*3,
    BRowIndex is ARowIndex+1,
    CRowIndex is ARowIndex+2,
    nth0(ARowIndex, B, ARow),
    nth0(BRowIndex, B, BRow),
    nth0(CRowIndex, B, CRow),
    AColIndex is (Col//3)*3,
    BColIndex is AColIndex+1,
    CColIndex is AColIndex+2,
    nth0(AColIndex, ARow, X0),
    nth0(BColIndex, ARow, X1),
    nth0(CColIndex, ARow, X2),
    nth0(AColIndex, BRow, X3),
    nth0(BColIndex, BRow, X4),
    nth0(CColIndex, BRow, X5),
    nth0(AColIndex, CRow, X6),
    nth0(BColIndex, CRow, X7),
    nth0(CColIndex, CRow, X8),
    noDouble([X0, X1, X2, X3, X4, X5, X6, X7, X8]).

/* Verify the board has only 1-9 on it */
boardFinished([H|T]) :- not(member(0,H)), boardFinished(T).
boardFinished([]).

/* Run as many 0 replacements as necessary until the board is complete */
solver(B, B) :- B \== [], boardFinished(B).
solver(B, FinB) :- replace0(B,NewB), solver(NewB, FinB).

/* Print a board from above followed by the solution(s) to that board */
solve() :- board(X), write("Board\n"), print(X), solver(X, Y), write("\nSolution\n"),print(Y).
