module Day2

@enum Direction forward up down

struct Instruction
    direction::Direction
    distance::Int
end

struct Position
    horiz::Int
    depth::Int
    aim::Int
end

parse_instruction(s::SubString{String})::Instruction = begin
    # will fail if dir is not a valid direction, but who cares!
    dir, dist = split(s, ' ')
    direction = begin
        if dir == "forward"
            forward
        elseif dir == "down"
            down
        elseif dir == "up"
            up
        end
    end
    distance = parse(Int, dist)
    return Instruction(direction, distance) 
end

parse_input(x::String)::Vector{Instruction} = parse_instruction.(split(x, "\n"))

read_input(fname::String)::Vector{Instruction} = open(fname, "r") do io
    return parse_input(read(io, String))
end


progress1(pos::Position, ins::Instruction)::Position = begin
    if ins.direction == forward
        Position(pos.horiz+ins.distance, pos.depth,0)
    elseif ins.direction == down
        Position(pos.horiz, pos.depth+ins.distance,0)
    elseif ins.direction == up
        Position(pos.horiz, pos.depth-ins.distance,0)
    end
end

progress2(pos::Position, ins::Instruction)::Position = begin
    if ins.direction == forward
        Position(pos.horiz+ins.distance, pos.depth + (pos.aim*ins.distance), pos.aim)
    elseif ins.direction == down
        Position(pos.horiz, pos.depth, pos.aim + ins.distance)
    elseif ins.direction == up
        Position(pos.horiz, pos.depth, pos.aim - ins.distance)
    end
end

solution_1()::Int = begin
    read_input("inputs/2_1") |> x->accumulate(progress1, x, init = Position(0,0,0))[end] |> p::Position -> p.horiz*p.depth
end

solution_2()::Int = begin
    read_input("inputs/2_2") |> x->accumulate(progress2, x, init = Position(0,0,0))[end] |> p::Position -> p.horiz*p.depth
end

println(solution_1())
println(solution_2())

end