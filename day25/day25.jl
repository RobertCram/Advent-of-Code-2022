module Day25

# https://adventofcode.com/2022/day/25

include("./../aoc.jl")

using .AOC

const SNAFU = Dict(
    '2' => 2,
    '1' => 1,
    '0' => 0,
    '-' => -1,
    '=' => -2,
)

function AOC.processinput(data)
    data = split(data, '\n')
end

function snafu2decimal(snafu)
    reduce((sum, i) -> sum += SNAFU[snafu[end-i+1]] * 5 ^ (i-1) , eachindex(snafu), init=0)
end

function decimal2snafu(decimal)
    result = []
    number = decimal       
    numberofdigits = Int(floor(log(5, decimal * 2 + 1)))
    for exp in numberofdigits:-1:0
        shifted = (5^exp - 1) ÷ 2
        digit = abs(number) > shifted ? (number + sign(number) * shifted) ÷ 5^exp : sign(number) * number ÷ 5^exp
        number = number - digit * 5 ^ exp
        push!(result, digit)
    end
    result
end

function solvepart1(numbers)
    digits = decimal2snafu(reduce((sum, number) -> sum += snafu2decimal(number), numbers, init = 0))
    join(map(digit -> first(filter(p -> p[2] == digit, pairs(SNAFU)))[1], digits))
end

puzzles = [
    Puzzle(25, "test 1", "input-test1.txt", solvepart1, "2=-1=0"),
    Puzzle(25, "deel 1", solvepart1, "2-==10--=-0101==1201"),
]

printresults(puzzles)

end