module Day13

struct FoldSpec
    paper_marks::BitMatrix
    folds::Vector{Vector{Int}}
end

parse_input(input::String)::FoldSpec = begin
    coords, folds = split(input, "\n\n")
    parsed_coords = [parse.(Int, x) for x in split.(split(coords, "\n"), ",")]
    parsed_folds = Vector{Int}[]
    for x in split(replace(folds, "fold along " => ""), "\n")
        parsed_x = split(x, "=")
        push!(
            parsed_folds, 
            parsed_x[begin] == "x" 
                ? [parse(Int, parsed_x[end]), 0] 
                : [0, parse(Int, parsed_x[end])]
            )
    end
    return FoldSpec(gen_paper_matrix(Matrix(hcat(parsed_coords...)')), parsed_folds)
end

read_input(fname::String)::FoldSpec = open(fname, "r") do io
    return parse_input(read(io, String))
end

function gen_paper_matrix(paper::Matrix{Int})::BitMatrix
    max_x = max(paper[:,begin]...) + 1
    max_y = max(paper[:,end]...) + 1
    pmatrix = zeros(Int, max_y, max_x) 
    for p_r in eachrow(paper)
        pmatrix[begin+p_r[end], begin+p_r[begin]] = 1
    end
    return pmatrix
end 

function fold_paper(paper::BitMatrix, fold::Vector{Int})::BitMatrix
    fold_axis=max(fold...)
    paper = fold[end] == 0 ? Matrix(paper') : paper
    (stay, flip)  = (paper[1:begin+fold_axis-1, :], paper[(begin+fold_axis+1:end), :][end:-1:begin, :])
    (f_y, s_y) = (size(flip)[begin], size(stay)[begin])
    (big, small, axis) = f_y < s_y ? (stay, flip, f_y-1) : (flip, stay, s_y-1)
    big[end-axis:end,:] .|= small
    fold[end] == 0 ? Matrix(big') : big
end

fold_once(foldspec::FoldSpec)::BitMatrix = fold_paper(foldspec.paper_marks, foldspec.folds[begin])

function fold_all(foldspec::FoldSpec)::BitMatrix
    paper = foldspec.paper_marks
    for f in foldspec.folds
        paper = fold_paper(paper, f)
    end
    return paper
end

solution_1() = read_input("inputs/13_1") |> fold_once |> sum
solution_2() = read_input("inputs/13_1") |> fold_all |> display

println(solution_1())
println(solution_2())

end