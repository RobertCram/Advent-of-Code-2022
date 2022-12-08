module Day7

# https://adventofcode.com/2022/day/7

include("./../aoc.jl")

using .AOC
using AbstractTrees

mutable struct Node 
    name::String
    size::Int64
    parent::Union{Node, Nothing}
    children::Vector{Node}
end

Node(name, size) = Node(name, size, nothing, Node[])
Node(name) = Node(name, 0)

AbstractTrees.children(n::Node) = n.children

function AOC.processinput(data)
    data = split(data, '\n')
end

function addchild(node, name, size = 0)
    child = Node(name, size)
    child.parent = node
    push!(node.children, child)
    return child
end

function findchild(node, name)
    for child in node.children
        child.name == name && return child
    end
    return nothing
end
  
function execute(currentnode, instruction, root)
    if startswith(instruction, "\$ cd /")
        currentnode = root
    elseif startswith(instruction, "\$ cd ..")
        currentnode = currentnode.parent
    elseif startswith(instruction, "\$ cd ")
        name = instruction[6:end]
        currentnode = findchild(currentnode, name)
    elseif startswith(instruction, "\$ ls")
        # ignore
    elseif startswith(instruction, "dir ")
        _, name = split(instruction)
        addchild(currentnode, name)
    else
        size, name = split(instruction)        
        addchild(currentnode, name, parse(Int, size))
    end
    currentnode
end

function createfilesystemtree(instructions)
    root = Node("/")
    currentnode = root
    foreach(instruction -> currentnode = execute(currentnode, instruction, root), instructions)
    root
end

function size(n::Node)
    n.size > 0 && return n.size
    sum(map(size, n.children))    
end

function directories(filesystemtree)
    filter(n -> n.size == 0, collect(StatelessBFS(filesystemtree)))
end

function directorysizes(filesystemtree)
    map(size, directories(filesystemtree))
end

function solvepart1(input) 
    filesystemtree = createfilesystemtree(input)
    sum(filter(s -> s <= 100000, directorysizes(filesystemtree)))
end

function solvepart2(input)
    filesystemtree = createfilesystemtree(input)
    targetsize = size(filesystemtree) - 40000000
    sort(filter(size -> size >= targetsize, directorysizes(filesystemtree)))[1]
end

puzzles = [
    Puzzle(7, "test 1", "input-test1.txt", solvepart1, 95437),
    Puzzle(7, "deel 1", solvepart1, 1454188),
    Puzzle(7, "test 2", "input-test1.txt", solvepart2, 24933642),
    Puzzle(7, "deel 2", solvepart2, 4183246)
]

printresults(puzzles)

end