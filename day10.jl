module Day10

using Statistics

reduce_chunks_in_string(input::SubString{String})::String = begin
    out = input
    while contains(out, r"\[\]|\(\)|{}|<>")
        out = replace(out, r"\[\]|\(\)|{}|<>" => "")
    end
    out
end

find_first_illegal(chunks::Vector{SubString{String}})::String = begin
    ends = filter(b->contains(")]}>", b), chunks)
    if !isempty(ends)
        ends[begin]
    else
        ""
    end
end

get_value(bracket::String)::Int = begin
    Dict(
        "(" => 3, ")" => 3,
        "[" => 57, "]" => 57,
        "{" => 1197,"}" => 1197,
        "<" => 25137,">" => 25137,
        "" => 0
    )[bracket]
end

get_completion_value(chunks::Vector{SubString{String}})::Int = begin
    score = 0
    for ch in chunks
        score = 5score + Dict(
            "(" => 1, ")" => 1,
            "[" => 2, "]" => 2,
            "{" => 3,"}" => 3,
            "<" => 4,">" => 4,
        )[ch]
    end 
    score
end

parse_input(input::String) = begin
    split(input, "\n") .|> reduce_chunks_in_string .|> x->split(x, "")
end

read_input(fname::String) = open(fname, "r") do io
    return parse_input(read(io, String))
end

solution_1() = read_input("inputs/10_1") .|> find_first_illegal |> x->filter(y->y!=="", x) .|> get_value |> sum
solution_2() = read_input("inputs/10_1") |> x->filter(y->find_first_illegal(y) == "", x) .|> reverse .|> get_completion_value |> sort |> median |> Int
println(solution_1())
println(solution_2())
end