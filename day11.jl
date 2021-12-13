module Day11

parse_input(input::String)::Matrix{Int} = begin
    hcat(
        map(split(input, "\n")) do line
            parse.(Int, collect(line))
        end...
    )
end

read_input(fname::String)::Matrix{Int} = open(fname, "r") do io
    return parse_input(read(io, String))
end

adjacent(ix::CartesianIndex{2}, octs::Matrix{Int})::Vector{CartesianIndex{2}} = [
    CartesianIndex(ix[1] + i, ix[2] + j) 
    for i in -1:1, j in -1:1 
        if checkbounds(Bool, octs, CartesianIndex(ix[1] + i, ix[2] + j)) 
            && (i, j) != (0, 0)
]

flash_octopuses!(octos::Matrix{Int})::Int = begin
    octos .+= 1
    flashed = findall(y->y>9, octos)
    for f in flashed
        adj = adjacent(f, octos)
        octos[adj] .+= 1
        for a in adj
            if octos[a] > 9 && !in(a, flashed)
                push!(flashed, a)
            end
        end
    end
    octos[flashed] .= 0
    return length(flashed)
end

find_flash_count(octos::Matrix{Int}, steps::Int)::Int = begin
    flashes = 0
    for _ in 1:steps 
        flashes += flash_octopuses!(octos)
    end
    return flashes
end

find_first_all_flash(octos::Matrix{Int})::Int = begin
    flashed = 0
    steps = 0
    while flashed < length(octos)
        steps += 1
        flashed = flash_octopuses!(octos)
    end
    return steps
end

solution_1()::Int = read_input("inputs/11_1") |> y->find_flash_count(y, 100)
solution_2()::Int = read_input("inputs/11_1") |> find_first_all_flash
println(solution_1())
println(solution_2())

end