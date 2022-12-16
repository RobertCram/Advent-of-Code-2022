module Day15

# https://adventofcode.com/2022/day/15

include("./../aoc.jl")

using .AOC

struct Sensor
    pos::Vector{Int}
    nearestbeacon::Vector{Int}
    distance::Int
end

function distance(p1, p2)
    abs(p1[1]-p2[1]) + abs(p1[2]-p2[2])
end

Sensor(a) = Sensor([a[1], a[2]], [a[3], a[4]], distance([a[1], a[2]], [a[3], a[4]]))

function parseline(line)
    line = split(line, '=')
    Sensor(parse.(Int, [line[2][1:end-3], line[3][1:end-24], line[4][1:end-3], line[5]]))
end

function AOC.processinput(data)
    data = split(data, '\n')
    map(parseline, data)
end

function beaconsandsensors(sensors, y)
    ybeacons = filter(sensor -> sensor.nearestbeacon[2] == y, sensors)
    ysensors = filter(sensor -> sensor.pos[2] == y, sensors)
    unique([map(sensor -> sensor.nearestbeacon[1]:sensor.nearestbeacon[1], ybeacons); map(sensor -> sensor.pos[1]:sensor.pos[1], ysensors)])
end

function coverage(sensor, y)
    linecoverage = sensor.distance - abs(y - sensor.pos[2])
    linecoverage < 0 && return 1:0
    return sensor.pos[1]-linecoverage:sensor.pos[1]+linecoverage
end

function coverage(sensors::Vector{Sensor}, y)
    filter(r -> length(r) > 0, map(sensor -> coverage(sensor, y), sensors))
end

function uncovered(ranges, max)
    sort!(ranges)
    currentrange = 0
    for i in eachindex(ranges)
        range = ranges[i]
        range[begin] > currentrange + 1 && return currentrange + 1
        range[end] <= currentrange && continue
        currentrange = range[end]
        currentrange > max && return nothing
    end
end

function solvepart1(sensors, line)
    length(setdiff(union(coverage(sensors, line)...), beaconsandsensors(sensors, line)...))
end

function solvepart2(sensors, max)
    x = 0
    y = 0
    while true
        x = uncovered([coverage(sensors, y); beaconsandsensors(sensors, y)], max)
        x !== nothing  && break
        y += 1
    end
    4000000 * x + y
end

puzzles = [
    Puzzle(15, "test 1", "input-test1.txt", data -> solvepart1(data, 10), 26),
    Puzzle(15, "deel 1", data -> solvepart1(data, 2000000), 4861076),
    Puzzle(15, "test 2", "input-test1.txt", data -> solvepart2(data, 20), 56000011),
    Puzzle(15, "deel 2", data -> solvepart2(data, 4000000), 10649103160102)
]

printresults(puzzles)

end