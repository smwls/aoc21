module Day12

mutable struct Tree{T}
    node::T
    parent::Union{Tree{T}, Nothing}
    children::Vector{Tree{T}}
end

function leaves(tree::Tree{T}, f::Function)::Vector{Tree{T}} where T
    if isempty(tree.children)
        f(tree) ? [tree] : []
    else
        collect(Iterators.Flatten(leaves(x, f) for x in tree.children))
    end
end

function leaf_nodes(tree::Tree{T})::Vector{T} where T
    if isempty(tree.children)
        [tree.node]
    else
        collect(Iterators.Flatten(leaf_nodes(x) for x in tree.children))
    end
end

function ancestors(child::Tree{T})::Vector{T} where T
    current_child = child
    ac = []
    while current_child.parent !== nothing
        push!(ac, current_child.parent)
        current_child = current_child.parent
    end
    [a.node for a in ac]
end

function parse_input(input::String)::Dict{String, Vector{String}}
    lines = split(input, "\n")
    adjacency_list = Dict()
    for l in lines
        fst, snd = String.(split(l, "-"))
        if !(fst in keys(adjacency_list))
            adjacency_list[fst] = []
        end
        if !(snd in keys(adjacency_list))
            adjacency_list[snd] = []
        end
        for (a, b) in [(fst, snd), (snd, fst)]
            if !(b in adjacency_list[a]) && b != "start" && a != "end"
                push!(adjacency_list[a], b)
            end
        end
    end
    return adjacency_list
end

read_input(fname::String)::Dict{String, Vector{String}} = open(fname, "r") do io
    return parse_input(read(io, String))
end

is_big(cave::String) = cave == uppercase(cave)

can_be_visited(n::String, acs::Vector{String}, max_visits::Int) = begin
    if !(n in acs)
        return true
    end
    if max_visits < 2
        return false
    end
    for x in filter(x->!is_big(x), acs)
        if count(acs .== x) > 1
            return false
        end
    end
    return true
end

function form_path_tree(caves::Dict{String, Vector{String}}, max_visits::Int)::Tree{String}
    cave_tree = Tree("start", nothing, Tree{String}[])
    for c in caves["start"]
        push!(cave_tree.children, Tree(c, cave_tree, Tree{String}[]))
    end
    to_visit = leaves(cave_tree, x->true)
    has_new_node = true
    while has_new_node
        has_new_node = false
        for tv in to_visit
            for ch in caves[tv.node]
                v_tree = Tree(ch, tv, Tree{String}[])
                acs = ancestors(tv)
                if !in(ch, leaf_nodes(tv)) && (is_big(ch) || can_be_visited(ch, acs, max_visits))
                    push!(tv.children, v_tree)
                    has_new_node |= has_new_node || ch != "end"
                end
            end
        end
        to_visit = leaves(cave_tree, x->x.node!="end" && (is_big(x.node) || can_be_visited(x.node, ancestors(x), max_visits)))
    end
    return cave_tree
end

solution_1() = read_input("inputs/12_1") |> x->form_path_tree(x, 1) |> y->length([l for l in leaves(y, x->x.node=="end")])
solution_2() = read_input("inputs/12_1") |> x->form_path_tree(x, 2) |> y->length([l for l in leaves(y, x->x.node=="end")])
println(solution_1())
println(solution_2())


end