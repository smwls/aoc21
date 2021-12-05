module Day5

struct Point
    x::Int
    y::Int
end

struct LineSegment
    a::Point
    b::Point
end

parse_pair(input::SubString{String})::Point = begin
    p = parse.(Int, split(input, ","))
    Point(p[begin], p[end])    
end

parse_line_segment(input::SubString{String})::LineSegment = begin
    ls = map(parse_pair, split(input, " -> "))
    LineSegment(ls[begin], ls[end])
end

parse_input(input::String)::Vector{LineSegment} = begin
    input |>
    x->split(x, "\n") |>
    x->map(parse_line_segment, x)
end

read_input(fname::String)::Vector{LineSegment} = open(fname, "r") do io
    return parse_input(read(io, String))
end

get_points_on_line(line::LineSegment)::Vector{Point} = begin
    if line.a.x == line.b.x
        s, e = sort([line.a.y, line.b.y])
        return [Point(line.a.x, s+i) for i in 0:(e-s)]
    elseif line.a.y == line.b.y
        s, e = sort([line.a.x, line.b.x])
        return [Point(s+i, line.a.y) for i in 0:(e-s)]
    elseif (line.a.y - line.b.y)/(line.a.x - line.b.x) < 0
        sx, ex = sort([line.a.x, line.b.x])
        ey, sy = sort([line.a.y, line.b.y])
        return [Point(sx+i,sy-i) for i in 0:(ex-sx)]
    else
        sx, ex = sort([line.a.x, line.b.x])
        sy, ey = sort([line.a.y, line.b.y])
        return [Point(sx+i,sy+i) for i in 0:(ex-sx)]
    end
end

mark_lines_on_point!(ocean_floor::Matrix{Int}, line::LineSegment) = begin
    for p in get_points_on_line(line)
        ocean_floor[p.y, p.x] += 1
    end
end

find_max_dims(lines::Vector{LineSegment})::Point = begin
    ps = vcat(map(x->x.a, lines), map(x->x.b, lines)) 
    max_x = max(map(x->x.x, ps)...)
    max_y = max(map(x->x.y, ps)...)
    Point(max_x+1, max_y+1)
end

get_all_lines(lines::Vector{LineSegment}, pred=y->true)::Matrix{Int} = begin
    max_dims = find_max_dims(lines)
    ocean_floor = zeros(Int, (max_dims.x, max_dims.y))
    for ls in filter(pred, lines)
        mark_lines_on_point!(ocean_floor, ls)
    end
    return ocean_floor
end

solution_1() = begin
    read_input("inputs/5_1") |> 
    x->get_all_lines(x, ls -> ls.a.x == ls.b.x || ls.a.y == ls.b.y) |> 
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