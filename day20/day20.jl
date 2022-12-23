module Day20

# https://adventofcode.com/2022/day/2

include("./../aoc.jl")

using .AOC

import Base.insert!, Base.delete!

mutable struct Node
    value::Int
    previous::Union{Node, Nothing}
    next::Union{Node, Nothing}
    Node(value, previous, next) = new(value, previous, next)
    Node(value::Int) = (n = new(); n.value = value;  n.previous = n; n.next = n)
end

function AOC.processinput(data)
    data = parse.(Int, split(data, '\n'))    
end

function delete(node::Node)
    node.next.previous = node.previous
    node.previous.next = node.next
end

function insert!(node::Node, toinsert::Node)
    toinsert.previous = node
    toinsert.next = node.next
    node.next.previous = toinsert
    node.next = toinsert
end

function fromarray(array)
    list = Node(array[1])
    node = list
    for value in array[2:end]
        node = insert!(node, Node(value))
    end
    list
end

function toarray(list::Node)
    result = (Node)[]
    node = list
    while true
        push!(result, node)
        ((node = node.next) == list) && break
    end
    result
end

function getnode(node::Node, count)
    count > 0 && foreach(_ -> node = node.next, 1:count)
    count < 0 && foreach(_ -> node = node.previous, 1:-count+1)
    node
end

function getcoordinate(node::Node, count)
    getnode(node, count).value
end

function move!(node::Node, datalength)
    node.value == 0 && return node
    delete(node)
    targetnode = getnode(node, mod(node.value - 1, datalength - 1) + 1)
    insert!(targetnode, node)
end

function coordinates(node::Node)    
    sum(map(i -> getcoordinate(node, i), [1000, 2000, 3000]))
end

function solve(data, decryptionkey = 1, mixes = 1)
    list = fromarray(decryptionkey .* data)
    originalorder = toarray(list)
    for _ in 1:mixes
        for node in originalorder
            move!(node, length(data))
        end
    end
    i = findfirst(n -> n.value == 0, originalorder)
    coordinates(originalorder[i]) 
end

function solvepart1(data) 
    solve(data)
end

function solvepart2(data)
    decryptionkey = 811589153
    mixes = 10
    solve(data, decryptionkey, mixes)
end

puzzles = [
    Puzzle(20, "test 1", "input-test1.txt", solvepart1, 3),
    Puzzle(20, "deel 1", solvepart1, 6640),
    Puzzle(20, "test 2", "input-test1.txt", solvepart2, 1623178306),
    Puzzle(20, "deel 2", solvepart2, 11893839037215)
]

printresults(puzzles)

end