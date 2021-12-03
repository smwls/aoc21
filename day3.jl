module Day3

parse_input(x::String)::Matrix{Int64} = begin
    # it should be easy to parse the whole string into a matrix "directly", without doing this...
    width = length(split(x, "\n")[begin])
    transpose(reshape(parse.(Int, split(replace(x, "\n" => ""), "")), (width, :)))
end

read_input(fname::String)::Matrix{Int64} = open(fname, "r") do io
    return parse_input(read(io, String))
end

bin_to_num(b::Vector{Int64})::Int = parse(Int, join(map(string, b)), base=2)

get_rate(x::Matrix{Int64})::Int = begin
    gamma_rate = map(x -> 2*sum(x) >= length(x) ? 1 : 0, eachcol(x))
    epsilon_rate = 1 .- gamma_rate
    return bin_to_num(gamma_rate)*bin_to_num(epsilon_rate)
end

get_oxygen_co2_rate(x::Matrix{Int64})::Int = begin
    gamma = a -> map(Bool, 2*sum(a) >= length(a) ? a : 1 .- a)
    epsilon = a -> .!gamma(a)
    current_o2_matrix = x
    current_co2_matrix = x
    for r in 1:size(x)[end]
        gam = gamma(current_o2_matrix[:,r])
        eps = epsilon(current_co2_matrix[:,r])
        if size(current_o2_matrix)[begin] > 1
            current_o2_matrix = current_o2_matrix[gam, :]
        end
        if size(current_co2_matrix)[begin] > 1
            current_co2_matrix = current_co2_matrix[eps, :]
        end
    end
    bin_to_num(vec(current_o2_matrix))*bin_to_num(vec(current_co2_matrix))
end

solution_1()::Int = read_input("inputs/3_1") |> get_rate
solution_2()::Int = read_input("inputs/3_1") |> get_oxygen_co2_rate

println(solution_1())
println(solution_2())

end