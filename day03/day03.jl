module Day3

# https://adventofcode.com/2022/day/3

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split(data, '\n')
end

function priority(item::Char)
    item < 'a' ? Int(item) - 38 : Int(item) - 96
end

function misplaceditem(content)
    first(intersect(content[1:length(content) ÷ 2], content[length(content) ÷ 2 + 1:end]))
end

function misplaceditempriority(content)
    priority(misplaceditem(content))
end

function groupby3(input)
    reduce((acc, e) -> (mod(e-1, 3) == 0 && push!(acc, [input[e], input[e+1], input[e+2]]); acc), 1:length(input), init = [])
end

function solvepart1(input)
    sum(map(misplaceditempriority, input))
end

function solvepart2(input)
    groupedinput = groupby3(input)
    badges = map(g -> first(intersect(g...)), groupedinput)
    sum(map(priority, badges))
end

puzzles = [
    Puzzle(3, "test 1", "input-test1.txt", solvepart1, 157),
    Puzzle(3, "deel 1", solvepart1, 8243),
    Puzzle(3, "test 2", "input-test1.txt", solvepart2, 70),
    Puzzle(3, "deel 2", solvepart2, 2631)
]


printresults(puzzles)

end