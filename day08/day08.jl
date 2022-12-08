module Day8

# https://adventofcode.com/2022/day/8

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = collect.(split(data, '\n'))
    data = parse.(Int, collect(Iterators.flatten(data)))
    reshape(data, (Int(sqrt(length(data))), :))'
end

function isvisible(trees, tree)
    length(filter(t -> t >= tree, trees)) == 0
end

function isvisible(input, x, y)
    rows, cols = size(input)
    sum(map(trees -> isvisible(trees, input[x, y]), [input[x, 1:y-1], input[x, y+1:cols], input[1:x-1, y], input[x+1:rows, y]])) > 0
end

function scenicscore(trees, tree)
    i = findfirst(t -> t >= tree, trees)
    i === nothing ? length(trees) : i
end

function scenicscore(input, x, y)
    rows, cols = size(input)
    reduce(*, map(trees -> scenicscore(trees, input[x, y]), [reverse(input[x, 1:y-1]), input[x, y+1:cols], reverse(input[1:x-1, y]), input[x+1:rows, y]]))
end

function maptrees(trees, mapping)
    rows, cols = size(trees)
    [mapping(trees, x, y) for x in 1:rows, y in 1:cols]
end

function solvepart1(input)
    sum(maptrees(input, isvisible))
end

function solvepart2(input)
    maximum(maptrees(input, scenicscore))
end

puzzles = [
    Puzzle(8, "test 1", "input-test1.txt", solvepart1, 21),
    Puzzle(8, "deel 1", solvepart1, 1805),
    Puzzle(8, "test 2", "input-test1.txt", solvepart2, 8),
    Puzzle(8, "deel 2", solvepart2, 444528)
]

printresults(puzzles)

end