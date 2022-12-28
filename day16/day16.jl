module Day16

# https://adventofcode.com/2022/day/16

include("./../aoc.jl")

using .AOC

struct ScanLine
    from::AbstractString
    to::Array{AbstractString}
    flowrate::Int
end

struct State
    tunnel1::String
    tunnel2::String
    valves::AbstractDict{String, Bool}
    pressure::Int
    time1::Int
    time2::Int
end 

State(tunnel, valves, pressure, time) = State(tunnel, tunnel, valves, pressure, time, time) 
State(tunnel, scanlines) = State(tunnel, tunnel, Dict{String, Bool}(valve => false for valve in keys(scanlines)), 0, 0, 0) 

function parseline(line)
    s1, s2 = split(line, ';')
    from = s1[7:8]
    flowrate = parse(Int, s1[24:end])
    to = split(replace(s2, "valves" => "valve")[24:end], ", ")    
    from => ScanLine(from, to, flowrate)
end

function AOC.processinput(data)
    data = split(data, '\n')
    Dict(map(parseline, data))
end

function prunestates(states)
    collect(values(reduce((acc, state) -> (maxpressure = get(acc, state.tunnel1 * state.tunnel2 * string(state.time1), state).pressure; (state.pressure >= maxpressure) && push!(acc, state.tunnel1 * state.tunnel2 * string(state.time1) => state); acc), states, init = Dict{String, State}())))
end

function setstate1(state, tunnel, valves, pressure, time)
    State(tunnel, state.tunnel2, valves, pressure, time, state.time2)
end

function setstate2(state, tunnel, valves, pressure, time)
    State(state.tunnel1, tunnel, valves, pressure, state.time1, time)
end

function getstate1(state)
    state.time1, state.tunnel1, setstate1
end

function getstate2(state)
    state.time2, state.tunnel2, setstate2
end

function nextstates(scanlines, state, totunnel, maxtime, getstate = getstate1)
    time, fromtunnel, setstate = getstate(state)
    time >= maxtime && return [state]
    valves = copy(state.valves)
    scanlines[fromtunnel].flowrate == 0 && return [setstate(state, totunnel, valves, state.pressure, time + 1)]
    valves[fromtunnel] && return [setstate(state, totunnel, valves, state.pressure, time + 1)]
    valveswhenopened = copy(valves)
    valveswhenopened[fromtunnel] = true
    [setstate(state, totunnel, valveswhenopened, state.pressure + scanlines[fromtunnel].flowrate * (maxtime - time - 1), time + 2), setstate(state, totunnel, valves, state.pressure, time + 1)]
end

function nextstates(scanlines, state::State, maxtime, elephanthelping)
    states = unique(Iterators.flatten(map(totunnel -> nextstates(scanlines, state, totunnel, maxtime, getstate1), scanlines[state.tunnel1].to)))
    if elephanthelping 
        newstates = []
        for state in states        
            push!(newstates, collect(Iterators.flatten(map(totunnel -> nextstates(scanlines, state, totunnel, maxtime, getstate2), scanlines[state.tunnel2].to)))...)
        end
        return newstates
    end
    return states
end

function nextstates(scanlines, states::Vector{State}, maxtime, elephanthelping = false)
    prunestates(unique(Iterators.flatten(map(state -> nextstates(scanlines, state, maxtime, elephanthelping), states))))
end

function solve(scanlines, maxtime; elephanthelping = false)
    states = [State("AA", scanlines)]
    while !isempty(filter(state -> (state.time1 < maxtime), states))
        states = nextstates(scanlines, states, maxtime, elephanthelping)
    end    
    maximum(map(state -> state.pressure, states))
end

function solvepart1(scanlines)
    solve(scanlines, 30)
end

function solvepart2(scanlines)
    solve(scanlines, 26; elephanthelping = true)
end

puzzles = [
    Puzzle(16, "test 1", "input-test1.txt", solvepart1, 1651),
    Puzzle(16, "deel 1", solvepart1, 1647),
    Puzzle(16, "test 2", "input-test1.txt", solvepart2, 1707),
    Puzzle(16, "deel 2", solvepart2, 2169)
]

printresults(puzzles)

end

