module Day1

parse_input(x::String)::Vector{Int} = parse.(Int, split(x, "\n"))

read_input(fname::String)::Vector{Int} = open(fname, "r") do io
    return parse_input(read(io, String))
end

flat(x::Int)::Int = x <= 0 ? 0 : 1

sliding_windows(v::Vector{Int}) = v[begin:end-2] + v[begin+1:end-1] + v[begin+2:end]

solution_1()::Int = read_input("inputs/1_1") |> diff .|> flat |> sum

solution_2()::Int = read_input("inputs/1_2") |> sliding_windows |> diff .|> flat |> sum

println(solution_1())
println(solution_2())

end