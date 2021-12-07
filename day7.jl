module Day7

parse_input(input::String)::Vector{Int} = begin
    input |>
    x->split(x, ",") |>
    x->parse.(Int, x)
end

read_input(fname::String)::Vector{Int} = open(fname, "r") do io
    return parse_input(read(io, String))
end

get_masses(positions::Vector{Int})::Vector{Int} = begin
    counts = zeros(Int, max(positions...) + 1)
    for f in positions
        counts[begin+f] += 1
    end
    return counts
end

get_min_fuel(ms::Vector{Int}, f::Function=x->x)::Int = begin
    max_ix = length(ms) - 1
    vs = f([i for i in 0:max_ix])
    avs = vcat(vs, vs[end-1:-1:begin+1])
    distmatrix = hcat([circshift(avs, i) for i in 0:2max_ix]...)[1:end-max_ix,1:end-max_ix]
    return min(distmatrix*ms...)
end

solution_1() = read_input("inputs/7_1") |> get_masses |> get_min_fuel
solution_2() = read_input("inputs/7_1") |> get_masses |> x->get_min_fuel(x, cumsum)

println(solution_1())
println(solution_2())
end