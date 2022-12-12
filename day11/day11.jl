module Day11

# https://adventofcode.com/2022/day/11

include("./../aoc.jl")

using .AOC

struct Monkey
    items::Vector{Int}
    operation::Function
    test::Function
end

mutable struct Game
    monkeys::Vector{Monkey}
    inspections::Vector{Int}
    currentround::Int
    currentplayer::Int
    decreaseworry::Function
end

Game(monkeys, decreaseworry) = Game(monkeys, [0 for i in 1 :length(monkeys)], 0 , 0, decreaseworry)

function AOC.processinput(data) 
    monkeys = []
    data = split(data, '\n')    
    if (data[1] == "TESTINPUT")     
        push!(monkeys, Monkey([79, 98], w -> w * 19, w -> mod(w, 23) == 0 ? 2 : 3))
        push!(monkeys, Monkey([54, 65, 75, 74], w -> w + 6, w -> mod(w, 19) == 0 ? 2 : 0))
        push!(monkeys, Monkey([79, 60, 97], w -> w * w, w -> mod(w, 13) == 0 ? 1 : 3))
        push!(monkeys, Monkey([74], w -> w + 3, w -> mod(w, 17) == 0 ? 0 : 1))
        greatestcommonmultiple = 23 * 19 * 13 * 17    
    elseif data[1] == "PUZZLEINPUT"
        push!(monkeys, Monkey([62, 92, 50, 63, 62, 93, 73, 50], w -> w * 7, w -> mod(w, 2) == 0 ? 7 : 1))
        push!(monkeys, Monkey([51, 97, 74, 84, 99], w -> w + 3, w -> mod(w, 7) == 0 ? 2 : 4))
        push!(monkeys, Monkey([98, 86, 62, 76, 51, 81, 95], w -> w + 4, w -> mod(w, 13) == 0 ? 5 : 4))
        push!(monkeys, Monkey([53, 95, 50, 85, 83, 72], w -> w + 5, w -> mod(w, 19) == 0 ? 6 : 0))
        push!(monkeys, Monkey([59, 60, 63, 71], w -> w * 5, w -> mod(w, 11) == 0 ? 5 : 3))
        push!(monkeys, Monkey([92, 65], w -> w * w  , w -> mod(w, 5) == 0 ? 6 : 3))
        push!(monkeys, Monkey([78], w -> w + 8 , w -> mod(w, 3) == 0 ? 0 : 7))
        push!(monkeys, Monkey([84, 93, 54], w -> w + 1, w -> mod(w, 17) == 0 ? 2 : 1))
        greatestcommonmultiple = 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19
    end
    monkeys, greatestcommonmultiple
end

function playmonkey!(game)
    monkey = game.monkeys[game.currentplayer+1]
    foreach(monkey.items) do item
        item = game.decreaseworry(monkey.operation(item))      
        push!(game.monkeys[monkey.test(item) + 1].items, item)
    end
    game.inspections[game.currentplayer+1] += length(monkey.items)
    empty!(monkey.items)    
    game.currentplayer += 1
end

function playround!(game)
    foreach(_ -> playmonkey!(game), game.monkeys)
    game.currentround += 1
    game.currentplayer = 0
end

function solve(monkeys, rounds, decreaseworry)
    game = Game(monkeys, decreaseworry)
    foreach(_ -> playround!(game), 1:rounds)
    sort!(game.inspections)
    game.inspections[end] * game.inspections[end - 1]
end

function solvepart1((monkeys, greatestcommonmultiple))
    solve(monkeys, 20, w -> w ÷ 3)
end

function solvepart2((monkeys, greatestcommonmultiple))
    solve(monkeys, 10000, w -> mod(w, greatestcommonmultiple))
end

puzzles = [
    Puzzle(11, "test 1", "input-test1.txt", solvepart1, 10605),
    Puzzle(11, "deel 1", solvepart1, 90882),
    Puzzle(11, "test 2", "input-test1.txt", solvepart2, 2713310158),
    Puzzle(11, "deel 2", solvepart2, 30893109657)
]

printresults(puzzles)

end