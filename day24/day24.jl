module Day24

# https://adventofcode.com/2022/day/24

include("./../aoc.jl")

using .AOC
import Base.+, Base.∈

const STEPS = [
    [-1, 0], 
    [1, 0], 
    [0, -1], 
    [0, 1],
    [0, 0],
]

const DIRECTIONS = Dict(
    '>' => [0, 1],
    '<' => [0, -1],
    '^' => [-1, 0],
    'v' => [1, 0],
)

struct Blizard
    position::Vector{Int64}
    direction::Char
end

struct State 
    x::Int64
    y::Int64
end

State() = State(0, 1)

(+)(state::State, vector::Vector{Int64}) = State(state.x + vector[1], state.y + vector[2])
(∈)(state::State, size::Tuple{Int64, Int64}) = (state.x > 0 && state.x <= size[1] && state.y > 0 && state.y <= size[2])


function AOC.processinput(data)
    data = collect.(split(data, '\n'))
    data = [data[row][col] for row in eachindex(data), col in eachindex(data[1])][2:end-1, 2:end-1]
    blizardcoords = findall(s -> s != '.', data)
    blizards = map(bc -> Blizard([Tuple(bc)...], data[bc]), blizardcoords)
    blizards, size(data)
end

function timestep(blizard::Blizard, size)
    position = blizard.position + DIRECTIONS[blizard.direction]
    position == [size[1] + 1, size[2]] && return Blizard(position, blizard.direction)
    position[1] < 1 && (position[1] = size[1])
    position[1] > size[1] && (position[1] = 1)
    position[2] < 1 && (position[2] = size[2])
    position[2] > size[2] && (position[2] = 1)
    Blizard(position, blizard.direction)
end

function timestep(blizards::Vector{Blizard}, size)
    map(blizard -> timestep(blizard, size), blizards)
end

function getblizards(initialblizards, timesteps, size)
    blizards = initialblizards
    foreach(_ -> blizards = timestep(blizards, size), 1:timesteps)
    blizards
end

function nextstates(state::State, blizards, size)    
    endpoints = [State(0, 1), State(size[1] + 1, size[2])]
    states = filter(s -> s ∈ endpoints || s ∈ size, map(step -> state + step, STEPS))
    states = setdiff(states, map(blizard -> State(blizard.position[1], blizard.position[2]), blizards))
    states
end

function nextstates(states::Vector{State}, blizards, size)
    unique(Iterators.flatten(map(state -> nextstates(state, blizards, size), states)))
end

function solve(state, initialblizards, initialtime, size)
    states = [state]
    time = initialtime
    endstate = State(size[1]+1, size[2])
    while true
        blizards = getblizards(initialblizards, time, size)
        states = nextstates(states, blizards, size)
        (endstate in states) && break
        time += 1
    end
    time
    # blizards = getblizards(initialblizards, time, size)
    # states = nextstates(states, blizards, size)
    # states = nextstates(states, blizards, size)
    # display(states)
end

function solvepart1(input)
    blizards, size = input
    solve(State(), blizards, 1, size)   
end

function solvepart2(input)
    blizards, size = input
    trip1 = solve(State(), blizards, 1, size)   
    trip2 = solve(State(size[1] + 1, size[2]), blizards, trip1 + 1, size)   
    solve(State(), blizards, trip1 + trip2 + 1, size)   
end

puzzles = [
    Puzzle(24, "test 1", "input-test1.txt", solvepart1, 18),
    Puzzle(24, "deel 1", solvepart1, 242),
    Puzzle(24, "test 2", "input-test1.txt", solvepart2, 54),
    Puzzle(24, "deel 2", solvepart2, 720)
]

@time printresults(puzzles)

end