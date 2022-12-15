module Day14

# https://adventofcode.com/2022/day/14

include("./../aoc.jl")

using .AOC

const STOP = CartesianIndex(-1, -1)

import Base.show
show(io::IO, scan::Array{Char,2}) = print(io, reduce((acc, r) -> acc *= join(r) * '\n', eachrow(scan), init = ""))

function parseline(line)
    parse.(Int, split(line, ','))
end

function parsepath(path)
    map(parseline, path)
end

function AOC.processinput(data)
    paths = split.(split(data, '\n'), " -> ")
    paths = map(parsepath, paths)
end

function topleftbottomright(paths)
    cols = Iterators.flatten(map(path -> map(line -> line[1], path), paths))
    rows = Iterators.flatten(map(path -> map(line -> line[2], path), paths))
    [0, minimum(cols)], [maximum(rows), maximum(cols)]    
end

function leftcol(paths)
    (_, leftcol), _ = topleftbottomright(paths)
    leftcol
end

function bottomrow(paths)
    _, (bottomrow, _) = topleftbottomright(paths)
    bottomrow
end

function normalize(paths)
    normalizer = [leftcol(paths), 0] 
    map(path -> map(line -> line .- normalizer, path), paths)
end

function emptymap(paths)
    tl, br = topleftbottomright(paths)
    ['.' for x in tl[1]:br[1], y in tl[2]:br[2]]
end

function getnormalizedsource(paths)
    500 - leftcol(paths) + 1
end

function drawpath(cavemap, path)
    for i in 2:size(path)[1]
        x₀, y₀ = path[i-1] + [1, 1]
        x, y = path[i] + [1, 1]
        x == x₀ && (range = CartesianIndex(minimum([y₀, y]), x):CartesianIndex(maximum([y₀, y]), x))
        y == y₀ && (range = CartesianIndex(y, minimum([x₀, x])):CartesianIndex(y, maximum([x₀, x])))
        cavemap[range] .= '#'
    end
end

function drawpaths(cavemap, paths)
    foreach(path -> drawpath(cavemap, path), paths)
    cavemap
end

function getcavemap(paths)
    paths = normalize(paths)
    map = emptymap(paths) 
    drawpaths(map, paths)
end

function drop(cavemap, row, col)
    obstaclerow = findfirst(e -> e !== '.', cavemap[row:end, col])
    obstaclerow === nothing && return STOP
    obstaclerow += row - 1
    (obstaclerow <= 1 || obstaclerow > size(cavemap)[1] || col <= 1 || col > size(cavemap)[2]-1) && return STOP
    cavemap[obstaclerow, col-1] !== '.' && cavemap[obstaclerow, col+1] !== '.' && return CartesianIndex(obstaclerow-1, col)
    cavemap[obstaclerow, col-1] == '.' && return drop(cavemap, obstaclerow, col-1)
    cavemap[obstaclerow, col+1] == '.' && return drop(cavemap, obstaclerow, col+1)
end

function solve(paths)
    cavemap = getcavemap(paths)
    source = getnormalizedsource(paths)
    count = 0 
    while (endpoint = drop(cavemap, 1, source)) != STOP
        cavemap[endpoint] = '⏺'
        count += 1
    end
    # println(cavemap) # uncomment to show cavemap
    count
end

function addbottomrock(paths)
    br = bottomrow(paths)
    push!(paths, [[500 - br - 2, br + 2], [500 + br + 2, br + 2]])
end

function solvepart1(paths)
    solve(paths)
end

function solvepart2(paths)    
    addbottomrock(paths)
    solve(paths)
end

puzzles = [
    Puzzle(14, "test 1", "input-test1.txt", solvepart1, 24),
    Puzzle(14, "deexl 1", solvepart1, 1061),
    Puzzle(14, "test 2", "input-test1.txt", solvepart2, 93),
    Puzzle(14, "deel 2", solvepart2, 25055)
]

printresults(puzzles)

end