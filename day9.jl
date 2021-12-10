module Day9

parse_input(input::String)::Matrix{Int} = begin
    hcat(
        map(split(input, "\n")) do line
            parse.(Int, collect(line))
        end...
    )'
end

read_input(fname::String)::Matrix{Int} = open(fname, "r") do io
    return parse_input(read(io, String))
end

get_surrounding_indices(floor_map::Matrix{Int}, ix::CartesianIndex{2})::Vector{CartesianIndex{2}} = [
    CartesianIndex(ix[1] + i, ix[2] + j) 
    for i in -1:1, j in -1:1 
        if checkbounds(Bool, floor_map, CartesianIndex(ix[1] + i, ix[2] + j)) 
            && abs(i + j) == 1
]


is_min_index(floor_map::Matrix{Int}, ix::CartesianIndex)::Bool = begin
    for i in get_surrounding_indices(floor_map, ix)
        if floor_map[i] <= floor_map[ix]
            return false
        end
    end
    return true
end

all_min_indices(floor_map::Matrix{Int})::Vector{CartesianIndex{2}} = [i for i in keys(floor_map) if is_min_index(floor_map, i)]

find_basin(floor_map::Matrix{Int}, min_index::CartesianIndex{2})::Vector{CartesianIndex{2}} = begin
    basin = [min_index]
    for ix in basin
        surrounding = get_surrounding_indices(floor_map, ix)
        for s in surrounding
            if floor_map[s] != 9 && (floor_map[s] > floor_map[ix]) && !in(s, basin)
                push!(basin, s)
            end
        end
    end
    basin
end

solution_1() = begin
    ins = read_input("inputs/9_1") 
    ins |> all_min_indices |> y->sum(ins[y] .+ 1)
end

solution_2() = begin
    ins = read_input("inputs/9_1")
    prod(sort([length(find_basin(ins, mi)) for mi in all_min_indices(ins)])[end-2:end])
end

println(solution_1())
println(solution_2())
end

