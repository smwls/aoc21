module Day5

parse_pair(input::SubString{String})::Vector{Int} = parse.(Int, split(input, ","))

parse_line_segment(input::SubString{String})::Matrix{Int} = begin
    input |>
    x->split(x, " -> ") |>
    x->map(parse_pair, x) |>
    x->vcat(x...) |>
    x->reshape(x, (2,2)) |>
    transpose
end

parse_input(input::String)::Vector{Matrix{Int}} = begin
    input |>
    x->split(x, "\n") |>
    x->map(parse_line_segment, x)
end

read_input(fname::String)::Vector{Matrix{Int}} = open(fname, "r") do io
    return parse_input(read(io, String))
end

get_points_on_line(line::Matrix{Int})::Vector{Vector{Int}} = begin
    diff = line[end,:] - line[begin,:]
    diff_d = map(x->x == 0 ? 0 : x/abs(x), diff)
    [line[begin,:] + i*diff_d for i in 0:max(abs.(diff)...)]
end

mark_lines_on_point!(ocean_floor::Matrix{Int}, line::Matrix{Int}) = begin
    for p in get_points_on_line(line)
        ocean_floor[begin+p[begin], begin+p[end]] += 1
    end
end

find_max_dims(lines::Vector{Matrix{Int}})::Int = begin
    lines |>
    x->vcat(x...) |>
    x->max(x...)+1
end

get_all_lines(lines::Vector{Matrix{Int}}, pred=y->true)::Matrix{Int} = begin
    max_dims = find_max_dims(lines)
    ocean_floor = zeros(Int, (max_dims, max_dims))
    for ls in filter(pred, lines)
        mark_lines_on_point!(ocean_floor, ls)
    end
    return ocean_floor
end

solution_1() = begin
    read_input("inputs/5_1") |> 
    x->get_all_lines(x, ls -> ls[begin,begin] == ls[end,begin] || ls[begin,end] == ls[end,end]) |> 
    x->length(filter(y->y>1, x))
end

solution_2() = begin
    read_input("inputs/5_1") |> 
    x->get_all_lines(x) |> 
    x->length(filter(y->y>1, x))
end

println(solution_1())
println(solution_2())

end