module Day13

# https://adventofcode.com/2022/day/13

include("./../aoc.jl")

using .AOC
using JSON

struct PacketPair
    left
    right
end

function AOC.processinput(data)
    data = split.(split(data, "\n\n"), '\n')
    map(pp -> PacketPair(JSON.parse(pp[1]), JSON.parse(pp[2])), data)
end

function compare(left::Int, right::Int)
    left < right && return 1
    left > right && return -1
    return 0
end

function compare(left::AbstractVector, right::AbstractVector)
    result = 0
    for i in eachindex(left)
        i > length(right) && (result = -1; break)
        result = compare(left[i], right[i])
        result in [-1, 1] &&  break        
    end
    result == 0 && length(left) < length(right) && return 1
    result
end

compare(left::Int, right::AbstractVector) = compare([left], right)

compare(left::AbstractVector, right::Int) = compare(left, [right])


# solve part 1

function allpaircomparisons(input)
    map(pp -> compare(pp.left, pp.right), input)
end

function correctlyorderedpairindices(packetpairs)
    findall(comparison -> comparison == 1, packetpairs)
end

function solvepart1(input)    
    (sum ∘ correctlyorderedpairindices ∘ allpaircomparisons)(input)
end

# solve part 2

function allpacketslist(input)
    reduce((acc, pp) -> push!(acc, pp.left, pp.right), input, init = [])
end

function sort(signal)
    sort!(signal, lt = (x, y) -> compare(x, y) == 1)
end

function decoderkey(signal, dividers)
    findfirst(e -> e == dividers[1], signal) * findfirst(e -> e == dividers[2], signal) 
end

function solvepart2(input)
    dividers = [[[2]], [[6]]]
    signal = [allpacketslist(input); dividers]
    sortedsignal = sort(signal)
    decoderkey(sortedsignal, dividers)    
end

puzzles = [
    Puzzle(13, "test 1", "input-test1.txt", solvepart1, 13),
    Puzzle(13, "deel 1", solvepart1, 4734),
    Puzzle(13, "test 2", "input-test1.txt", solvepart2, 140),
    Puzzle(13, "deel 2", solvepart2, 21836)
]

printresults(puzzles)

end