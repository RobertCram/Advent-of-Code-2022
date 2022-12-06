module Day5

# https://adventofcode.com/2022/day/5

include("./../aoc.jl")

using .AOC
using DataStructures

struct Instruction
    number::Int
    from::Int
    to::Int
end

function parsecraterow(row)
    reduce((acc, e) -> (mod(e-1, 4) == 0 && push!(acc, row[e+1]); acc), 1:length(row), init=[])
end

function pushcrates!(stacks, craterow)
    foreach(e -> e[2] != ' ' && push!(stacks[e[1]], e[2]), enumerate(craterow))
end

function parsestacks(input)
    rows = split(input, '\n')
    nrofstacks = parse(Int, maximum(split(rows[end])))
    stacks = [Stack{Char}() for _ in 1:nrofstacks]
    craterows = reverse(map(parsecraterow, rows[1:end-1]))
    foreach(createrow -> pushcrates!(stacks, createrow), craterows)
    stacks
end

function parseinstructionrow(row)
    s = split(row)
    Instruction(parse(Int, s[2]), parse(Int, s[4]), parse(Int, s[6]))
end

function parseinstructions(input)
    rows = split(input, '\n')
    map(parseinstructionrow, rows)
end

function AOC.processinput(data)
    data = split(data, "\n\n")
    stacks = parsestacks(data[1])
    instructions = parseinstructions(data[2])
    stacks, instructions
end

function popn!(stack, number)
   reduce((acc, e) -> acc *= pop!(stack), 1:number, init="") 
end

function pushn!(stack, s)
  foreach(i -> push!(stack, s[i]), 1:length(s))
end

function executeinstruction!(stacks, instruction, cratemover)
    pushn!(stacks[instruction.to], cratemover(popn!(stacks[instruction.from], instruction.number)))
end

function executeinstructions!(stacks, instructions, cratemover)
    foreach(instruction -> executeinstruction!(stacks, instruction, cratemover), instructions)
end

function toplayer(stacks)
    reduce((acc, stack) -> acc *= pop!(stack), stacks, init="")
end

function solve(input, execute)
    stacks, instructions = input
    executeinstructions!(stacks, instructions, execute)
    toplayer(stacks)
end

function solvepart1(input)
    cratemover9000 = identity
    solve(input, cratemover9000) 
end

function solvepart2(input)
    cratemover9001 = reverse
    solve(input, cratemover9001)
end

puzzles = [
    Puzzle(5, "test 1", "input-test1.txt", solvepart1, "CMZ"),
    Puzzle(5, "deel 1", solvepart1, "VQZNJMWTR"),
    Puzzle(5, "test 2", "input-test1.txt", solvepart2, "MCD"),
    Puzzle(5, "deel 2", solvepart2, "NLCDCLVMQ")
]

printresults(puzzles)

end