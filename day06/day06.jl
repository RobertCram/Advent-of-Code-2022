module Day6

# https://adventofcode.com/2022/day/6

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split(data, '\n')
end

function startofmarker(datastream, size)
    for i in size:length(datastream)
        possiblemarker = datastream[i-size+1:i] 
        length(Set(possiblemarker)) == length(possiblemarker) && return i
    end
end

function startofpacketmarker(datastream)
    startofmarker(datastream, 4)
end

function startofmessagemarker(datastream)
    startofmarker(datastream, 14)
end
  
function solvepart1(input)
    map(startofpacketmarker, input)
end

function solvepart2(input)
    map(startofmessagemarker, input)
end

puzzles = [
    Puzzle(6, "test 1", "input-test1.txt", solvepart1, [7, 5, 6, 10, 11]),
    Puzzle(6, "deel 1", solvepart1, [1361]),
    Puzzle(6, "test 2", "input-test1.txt", solvepart2, [19, 23, 23, 29, 26]),
    Puzzle(6, "deel 2", solvepart2, [3263])
]

printresults(puzzles)

end