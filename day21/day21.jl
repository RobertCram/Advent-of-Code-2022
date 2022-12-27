module Day21

# https://adventofcode.com/2022/day/21

include("./../aoc.jl")

using .AOC

struct Monkey
    name::String
    value::Union{Int, Nothing}
    monkey1::Union{String, Nothing}
    monkey2::Union{String, Nothing}
    operation::Union{Char, Nothing}
end

const OPERATIONS = Dict(
    '+' => +,
    '-' => -,
    '*' => *,
    '/' => /,
    '=' => ==,
)

Monkey(name, value) = Monkey(name, value, nothing, nothing, nothing)

function parseline(line)
    parts = split(line)
    name = parts[1][1:end-1]
    length(parts) == 2 && return Monkey(name, parse(Int, parts[2]))
    Monkey(name, nothing, parts[2], parts[4], parts[3][1])    
end

function AOC.processinput(data)
    data = split(data, '\n')
    data = map(parseline, data)
    Dict(monkey.name => monkey for monkey in data)
end

function calculate(monkeys, monkey)
    monkey.value !== nothing && return monkey.value
    return OPERATIONS[monkey.operation](calculate(monkeys, monkeys[monkey.monkey1]), calculate(monkeys, monkeys[monkey.monkey2])) 
end

function solvepart1(monkeys)
    Int(calculate(monkeys, monkeys["root"]))
end

function solvepart2(monkeys)
    root = monkeys["root"]
    monkeys[root.name] = Monkey(root.name, root.value, root.monkey1, root.monkey2, '=')
    target = calculate(monkeys, monkeys[root.monkey2])
    humn = monkeys["humn"]

    # right part is constant, left part is monotonic decreasing function - do a binary search
    guesses = [0, typemax(Int64)]
    while true
        monkeys[humn.name] = Monkey(humn.name, (guesses[1] + guesses[2]) ÷ 2, humn.monkey1, humn.monkey2, humn.operation)
        result = calculate(monkeys, monkeys[root.monkey1])
        result == target && break
        result < target && (guesses[1] = (guesses[1] + guesses[2]) ÷ 2)
        result > target && (guesses[2] = (guesses[1] + guesses[2]) ÷ 2)    
    end
    (guesses[1] + guesses[2]) ÷ 2
end

puzzles = [
    Puzzle(21, "test 1", "input-test1.txt", solvepart1, 152),
    Puzzle(21, "deel 1", solvepart1, 43699799094202),
    Puzzle(21, "test 2", "input-test1.txt", solvepart2, 301),
    Puzzle(21, "deel 2", solvepart2, 3375719472770)
]

printresults(puzzles)

end