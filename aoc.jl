module AOC

export Puzzle, processinput, printresults

struct Puzzle
    day
    name
    inputfilename
    solve
    answer
end

import Pkg
Pkg.activate(".", io = devnull)

processinput(data) = data

Puzzle(day, name, solve, answer) = Puzzle(day, name, "input.txt", solve, answer)

function solve(puzzle::Puzzle)
    input = rawinput(puzzle)
    answer = puzzle.solve(input)
    if puzzle.answer === nothing
        "Het vermoedelijke antwoord van puzzel dag $(puzzle.day) - $(puzzle.name) is: $(answer)"
    elseif answer == puzzle.answer
        green("Het antwoord van puzzel dag $(puzzle.day) - $(puzzle.name) is: $(answer)")
    else
        red("Het antwoord van puzzel dag $(puzzle.day) -  $(puzzle.name) is: $(answer), maar moet zijn: $(puzzle.answer)")
    end
end

function getresults(puzzles::Array)
    map(p -> solve(p), puzzles)
end

function printresults(puzzles::Array)
    println(join(getresults(puzzles), "\n"))
end

function rawinput(puzzle::Puzzle)
    filename = "day$(lpad(puzzle.day, 2, "0"))/$(puzzle.inputfilename)" 
    !isfile(filename) && return ""

    open(filename) do io
        processinput(read(io, String))
    end
end

function colorize(str, colorcode)
    "\e[$(colorcode)m$(str)\e[0m"
end

function red(str)
    colorize(str, 31)
end

function green(str)
    colorize(str, 32)
end

end