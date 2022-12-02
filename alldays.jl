function clearterminal()
    print("\033c")
end

function bold(str)
    "\033[1m$(str)\033[0m"
end

function gray(str)
    "\e[2m$(str)\e[0m"
end

function showday(i)
    filename = "day$(lpad(i, 2, "0"))/day$(lpad(i, 2, "0")).jl"
    !isfile(filename) && return false

    println()
    println("Day $(i)")
    include(filename)
    return true
end

import Pkg
Pkg.activate("")

clearterminal()
println()
println(bold("Advent of Code 2022"))

for i in 1:25
    stats = @timed showday(i) || break
    println(gray("Elapsed time (in secs): $(stats.time)"))
end
