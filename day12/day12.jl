module Day12

# https://adventofcode.com/2022/day/12

include("./../aoc.jl")

using .AOC

function startend(heightmap)
    S = findfirst(x -> x== -14, heightmap)
    E = findfirst(x -> x== -28, heightmap)
    S, E
end

function AOC.processinput(data)
    data = (collect.(split(data, '\n')))
    l = length(data[1])
    data = Int.(Iterators.flatten(data)) .- 97
    heightmap = reshape(data, l, :)'
    S, E = startend(heightmap)
    heightmap[S] = 0
    heightmap[E] = 25
    heightmap, S, E
end

function neighbours(position::CartesianIndex, size)
    x, y = Tuple(position)
    filter(ci -> (ci[1] > 0) && (ci[2] > 0) && (ci[1] <= size[1]) && (ci[2] <= size[2]), CartesianIndex.([(x+1, y), (x-1, y), (x, y+1), (x, y-1)]))
end

function possiblesteps(position::CartesianIndex{2}, heightmap)
    filter(pos -> heightmap[pos] <= heightmap[position]+1, neighbours(position, size(heightmap)))
end

function possiblesteps(positions:: Vector{CartesianIndex{2}}, heightmap)
    collect(Iterators.flatten(map(position -> possiblesteps(position, heightmap), positions)))
end

function getpathlength(heightmap, startingpoint, endpoint)
    visited = [startingpoint]
    steps = visited
    i = 0
    while true 
        i += 1
        steps = possiblesteps(steps, heightmap)
        steps = setdiff(steps, visited)
        push!(visited, steps...)
        endpoint in steps && break
        isempty(steps) && (i = typemax(Int); break)
    end
    i
end

function solvepart1(input)
    heightmap, S, E = input
    getpathlength(heightmap, S, E)  
end

function solvepart2(input)
    heightmap, _, E = input
    pathlength(startingpoint) = getpathlength(heightmap, startingpoint, E)
    startingpoints = findall(x -> x == 0, heightmap)
    minimum(map(pathlength, startingpoints))
end

puzzles = [
    Puzzle(12, "test 1", "input-test1.txt", solvepart1, 31),
    Puzzle(12, "deel 1", solvepart1, 361),
    Puzzle(12, "test 2", "input-test1.txt", solvepart2, 29),
    Puzzle(12, "deel 2", solvepart2, 354)
]

printresults(puzzles)

end