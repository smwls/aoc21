module Day8

struct SignalOutput
    signal::BitMatrix
    output::BitMatrix
end

to_bitvector(x::SubString{String})::BitVector =  [contains(x, a) for a in "abcdefg"]

parse_input_line(input::SubString{String})::SignalOutput = begin
    signal, output = split.(split(input, " | "), ' ')
    SignalOutput(hcat(to_bitvector.(signal)...)', hcat(to_bitvector.(output)...)')
end

parse_input(input::String)::Vector{SignalOutput} = parse_input_line.(split(input, "\n"))

read_input(fname::String)::Vector{SignalOutput} = open(fname, "r") do io
    return parse_input(read(io, String))
end

count_simple(sig::Vector{SignalOutput})::Int = begin
    length(filter(x->in(x, [2,3,4,7]),vcat(map(x->x*ones(Int, 7), map(x->x.output, sig))...)))
end

decode(s::SignalOutput)::SignalOutput = begin
    sig = s.signal
    with_segments = z->[y for y in eachrow(sig) if sum(y) == z] 
    one, four, seven, eight = map(y->y[begin], with_segments.([2, 4, 3, 7]))
    two_three_five, zero_six_nine = with_segments.([5, 6])
    three = [y for y in two_three_five if sum(y.*one) == sum(one)][begin]
    nine = [y for y in zero_six_nine if sum(y.*three) == sum(three)][begin]
    five, six = [(y, z) for y in two_three_five, z in zero_six_nine if sum(y.*z) == sum(y) && y != three && z != nine][begin]
    two, zero = [(y, z) for y in two_three_five, z in zero_six_nine if y != five && y != three && z != six && z != nine][begin]
    return SignalOutput(hcat(zero, one, two, three, four, five, six, seven, eight, nine)', s.output)
end

read_with_decoded(s::SignalOutput) = begin
    decoded = []
    for out in eachrow(s.output)
        for (i, sig) in enumerate(eachrow(s.signal))
            if sig == out
                push!(decoded, i-1)
            end
        end
    end
    return sum(decoded .* [1000, 100, 10, 1])
end

solution_1() = read_input("inputs/8_1") |> count_simple
solution_2() = read_input("inputs/8_1") .|> decode .|> read_with_decoded |> sum

println(solution_1())
println(solution_2())
end