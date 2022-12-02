module Day2

# https://adventofcode.com/2022/day/2

include("./../aoc.jl")

using .AOC

# X, Y, Z - rock, paper, scissors
const SCORES1 = Dict(
    "A X" => 4,
    "A Y" => 8,
    "A Z" => 3,
    "B X" => 1,
    "B Y" => 5,
    "B Z" => 9,
    "C X" => 7,
    "C Y" => 2,
    "C Z" => 6     
)

# X, Y, Z - lose, draw, win
const SCORES2 = Dict(
    "A X" => 3,
    "A Y" => 4,
    "A Z" => 8,
    "B X" => 1,
    "B Y" => 5,
    "B Z" => 9,
    "C X" => 2,
    "C Y" => 6,
    "C Z" => 7      
)

function AOC.processinput(data)
    data = split(data, '\n')
end

function solve(input, scores)
    sum(map(x -> scores[x], input))
end

function solvepart1(input)
    solve(input, SCORES1)
end

function solvepart2(input)
    solve(input, SCORES2)
end

puzzles = [
    Puzzle(2, "test 1", "input-test1.txt", solvepart1, 15),
    Puzzle(2, "deel 1", solvepart1, 10994),
    Puzzle(2, "test 2", "input-test1.txt", solvepart2, 12),
    Puzzle(2, "deel 2", solvepart2, 12526)
]

printresults(puzzles)

end