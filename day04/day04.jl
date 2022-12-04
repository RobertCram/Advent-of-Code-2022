module Day4

# https://adventofcode.com/2022/day/4

include("./../aoc.jl")

using .AOC

struct Section
    first::Integer
    last::Integer
end

function parseline(line)
    line = split(line, ',')
    map(s -> Section(parse.(Int, split(s, "-"))...), line)
end

function AOC.processinput(data)
    data = split(data, '\n')
    map(parseline, data)    
end

function contains(pair)
    (pair[1].first <= pair[2].first && pair[1].last >= pair[2].last) || (pair[2].first <= pair[1].first && pair[2].last >= pair[1].last)
end

function overlaps(pair)
    !(pair[1].last < pair[2].first || pair[1].first > pair[2].last)
end

function solvepart1(input)
    sum(map(contains, input))
end

function solvepart2(input)
    sum(map(overlaps, input))
end

puzzles = [
    Puzzle(4, "test 1", "input-test1.txt", solvepart1, 2),
    Puzzle(4, "deel 1", solvepart1, 456),
    Puzzle(4, "test 2", "input-test1.txt", solvepart2, 4),
    Puzzle(4, "deel 2", solvepart2, 808)
]

printresults(puzzles)

end