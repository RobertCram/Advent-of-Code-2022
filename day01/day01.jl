module Day1

# https://adventofcode.com/2022/day/1

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    groupeddata = split.(split(data, "\n\n"), "\n")
    sort(map(a -> sum(parse.(Int, a)), groupeddata))
end

function solvepart1(input)
    input[end]
end

function solvepart2(input)
    sum(input[end-2:end])
end

puzzles = [
    Puzzle(1, "test 1", "input-test1.txt", solvepart1, 24000),
    Puzzle(1, "deel 1", solvepart1, 70369),
    Puzzle(1, "test 2", "input-test1.txt", solvepart2, 45000),
    Puzzle(1, "deel 2", solvepart2, 203002)
]

printresults(puzzles)

end