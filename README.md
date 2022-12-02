# Advent of Code 2022 (in Julia)

[Advent of Code](https://adventofcode.com) is an Advent calendar of small programming puzzles for a variety of skill sets and skill levels that can be solved in any programming language you like. People use them as a speed contest, interview prep, company training, university coursework, practice problems, or to challenge each other.

I'd like to get more familiar with the [Julia](https://julialang.org) language, so I am using it to solve the AoC puzzles.
<br /> 
<br /> 

## Setup
Make sure [Docker](https://www.docker.com/products/docker-desktop) and [Visual Studio Code](https://code.visualstudio.com) are installed. Add the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension to Visual Studio Code. Clone the repository and open it in Visual Studio Code. No other installation needed.
<br /> 
<br /> 

## Running the code
```bash
julia alldays.jl # runs the code for all days

julia day<day>/day<day>.jl # runs the code for the specific day
```
<br /> 

## Version Info

versioninfo() output:

```
Julia Version 1.8.3
Commit 0434deb161e (2022-11-14 20:14 UTC)
Platform Info:
  OS: Linux (aarch64-linux-gnu)
  CPU: 5 × unknown
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-13.0.1 (ORCJIT, generic)
  Threads: 1 on 5 virtual cores
```