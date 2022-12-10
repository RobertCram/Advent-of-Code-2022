module Day10

# https://adventofcode.com/2022/day/1

include("./../aoc.jl")

using .AOC


function AOC.processinput(data)
    data = split(data, '\n')
end

function cumulate(array, initialvalue = 0)
    map(i -> reduce(+, array[1:i], init=initialvalue), 1:length(array))
end

function registercontent(targetcycle, cumulativecycles, cumulativeadditions)
    i = findlast(c -> c < targetcycle, cumulativecycles)    
    i === nothing ? 1 : cumulativeadditions[i]
end

function cumulations(instructions)
    cycles = cumulate(map(instruction -> instruction == "noop" ? 1 : 2, instructions))
    additions = cumulate(map(instruction -> instruction == "noop" ? 0 : parse(Int, split(instruction)[2]), instructions), 1)
    cycles, additions
end

function solvepart1(instructions)
    cycles, additions = cumulations(instructions)
    sum(map(c -> c * registercontent(c, cycles, additions), [20 + i * 40 for i in 0:5]))
end

function solvepart2(instructions)
    cycles, additions = cumulations(instructions)
    spritepositions = map(c -> registercontent(c, cycles, additions), 1:cycles[end])
    answer = join(map(i -> mod(i-1, 40) in spritepositions[i]-1:spritepositions[i]+1 ? "#" : '.', 1:length(spritepositions)))
    checksum(answer)
end

const TESTANSWER = "##..##..##..##..##..##..##..##..##..##..###...###...###...###...###...###...###.####....####....####....####....####....#####.....#####.....#####.....#####.....######......######......######......###########.......#######.......#######....."
const ANSWER = "###....##.####.###..###..####.####..##..#..#....#.#....#..#.#..#.#....#....#..#.#..#....#.###..#..#.#..#.###..###..#....###.....#.#....###..###..#....#....#....#.#..#..#.#....#.#..#....#....#....#..#.#..#..##..####.#..#.#....####.#.....##.."

# calculates sum of lit pixels on CRT - only used to make it easier tot test the answer.
function checksum(s)
    reduce((acc, i) -> acc += (s[i] == '#' ? i : 0), 1:length(s), init=0)
end

function showcrt()
    println()
    foreach(i -> println(ANSWER[40 * i + 1:40 * (i+1)]), 0:5)
    println()
end

puzzles = [
    Puzzle(10, "test 1", "input-test1.txt", solvepart1, 13140),
    Puzzle(10, "deel 1", solvepart1, 14160),
    Puzzle(10, "test 2", "input-test1.txt", solvepart2, checksum(TESTANSWER)),
    Puzzle(10, "deel 2", solvepart2, checksum(ANSWER)) # CRT shows: RJERPEFC
]

printresults(puzzles)

# showcrt()

end