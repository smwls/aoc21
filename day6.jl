module Day6

parse_input(input::String)::Vector{Int} = begin
    input |>
    x->split(x, ",") |>
    x->parse.(Int, x)
end

read_input(fname::String)::Vector{Int} = open(fname, "r") do io
    return parse_input(read(io, String))
end

build_fish_counts(fs::Vector{Int})::Vector{Int} = begin
    counts = zeros(Int, 9)
    for f in fs
        counts[begin+f] += 1
    end
    return counts
end

iterate_fish_population(initial_cs::Vector{Int}, days::Int)::Vector{Int} = begin
    transition_matrix = [
        0 1 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0 0;
        0 0 0 1 0 0 0 0 0;
        0 0 0 0 1 0 0 0 0;
        0 0 0 0 0 1 0 0 0;
        0 0 0 0 0 0 1 0 0;
        1 0 0 0 0 0 0 1 0;
        0 0 0 0 0 0 0 0 1;
        1 0 0 0 0 0 0 0 0;
    ]
    return (transition_matrix^days)*initial_cs
end

solution_1() = 
    read_input("inputs/6_1") |> 
    build_fish_counts |> 
    x->iterate_fish_population(x, 80) |> 
    sum
solution_2() = 
    read_input("inputs/6_1") |> 
    build_fish_counts |> 
    x->iterate_fish_population(x, 256) |> 
    sum
println(solution_1())
println(solution_2())

end