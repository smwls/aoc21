module Day4

struct Bingo
    rands::Vector{Int}
    boards::Vector{Matrix{Int}}
end

parse_input(x::String)::Bingo = begin
    rands = parse.(Int, split(split(x, "\n")[begin], ','))
    boards = begin
        all_boards_string = split(x, "\n\n")[begin+1:end]
        map(all_boards_string) do board
            replace(board, r"[\n ]+" => " ") |> 
            strip |> 
            x->split(x, " ") |> 
            x->parse.(Int, x) |> 
            x->reshape(x, (5,5)) |> 
            transpose
        end
    end
    Bingo(rands, boards)
end

read_input(fname::String)::Bingo = open(fname, "r") do io
    return parse_input(read(io, String))
end

has_bingo(marked::BitMatrix)::Bool = any(rc->sum(rc) == length(rc), Iterators.Flatten((eachrow(marked), eachcol(marked))))

mark!(n::Int, board::Matrix{Int}, marked::BitMatrix) = begin
    for i in eachindex(board)
        if board[i] == n
            marked[i] = true
        end
    end
end

play_bingo(bb::Bingo)::Vector{Int} = begin
    nums = bb.rands
    boards = bb.boards
    bingo_completed = map(b->false, boards)
    bingo_scores = []
    marked = map(b -> falses(size(b)), boards)
    for n in nums
        for (b, m, i) in zip(boards, marked, eachindex(bingo_completed))
            mark!(n, b, m)
            if has_bingo(m) & !bingo_completed[i]
                push!(bingo_scores, n*sum(b .* .!m))
                bingo_completed[i] = true
            end
        end
    end
    return bingo_scores
end

solution_1() = read_input("inputs/4_1") |> play_bingo |> x->x[begin]
solution_2() = read_input("inputs/4_1") |> play_bingo |> x->x[end]
println(solution_1())
println(solution_2())
end
