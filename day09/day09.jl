module Day9

# https://adventofcode.com/2022/day/9

include("./../aoc.jl")

using .AOC

struct Motion
    direction::Vector{Int}
    distance::Int
end

const Direction = Dict(
    "U" => [1, 0],
    "D" => [-1, 0],
    "L" => [0, -1],
    "R" => [0, 1],
)

function AOC.processinput(data)
    data = split.(split(data, '\n'))
    map(m -> Motion(Direction[m[1]], parse(Int, m[2])), data)
end

function movetail(headposition, tailposition)
    direction = headposition - tailposition
    distance = abs.(direction)
    (distance[1] <= 1) && (distance[2] <= 1) && return tailposition
    (distance[1] + distance[2]) in [2,4] && return tailposition + div.(direction, 2)
    return tailposition + sign.(direction) 
end

function moverope!(tailpositions, rope, motion)
    foreach(1:motion.distance) do _
        rope[1] += motion.direction
        foreach(i -> rope[i+1] = movetail(rope[i], rope[i+1]), 1:length(rope)-1)
        push!(tailpositions, rope[end])
    end
end

function moverope(rope, motionlist)
    tailpositions = [[0,0]]
    foreach(m -> moverope!(tailpositions, rope, m), motionlist)
    length(unique(tailpositions))
end

function solvepart1(motionlist)
    rope = [[0, 0] for i in 1:2]
    moverope(rope, motionlist)
end

function solvepart2(motionlist)
    rope = [[0, 0] for i in 1:10]
    moverope(rope, motionlist)
end

puzzles = [
    Puzzle(9, "test 1", "input-test1.txt", solvepart1, 13),
    Puzzle(9, "deel 1", solvepart1, 6044),
    Puzzle(9, "test 2a", "input-test1.txt", solvepart2, 1),
    Puzzle(9, "test 2b", "input-test2.txt", solvepart2, 36),
    Puzzle(9, "deel 2", solvepart2, 2384)
]

printresults(puzzles)

end