module Day14

mutable struct PolymerString
    template::String
    rules::Dict{String, String}
end

mutable struct PolymerMatrix
    monomers::Vector{String}
    monomer_pairs::Vector{String}
    template::Vector{Int}
    begin_elt::String
    end_elt::String
    rules::Matrix{Int}
end

gen_rule(pair::String)::Pair = begin
    (from, to) = split(pair, " -> ")
    from => "$(from[begin])$(to)$(from[end])"
end

find_all_monomers(polymer_string::PolymerString)::Vector{String} = begin
    polymer_string.rules |>
        x->(String.(keys(x)), String.(values(x))) |>
        z->vcat(polymer_string.template, z...) |>
        join .|>
        z->split(z, "") |>
        unique |>
        sort
end

gen_matrix_and_initial_state(polymer_string::PolymerString)::PolymerMatrix = begin
    monomers = find_all_monomers(polymer_string)
    monomer_pairs = vec(["$(a)$(b)" for a in monomers, b in monomers])
    rule_matrix = zeros(Int, length(monomer_pairs), length(monomer_pairs))
    init_vec = zeros(Int, length(monomer_pairs))
    for (i, m_pair) in enumerate(monomer_pairs)
        if haskey(polymer_string.rules, m_pair)
            new_triple = polymer_string.rules[m_pair]
            (np_1, np_2) = (new_triple[begin:end-1], new_triple[begin+1:end])
            for (j, n_pair) in enumerate(monomer_pairs)
                rule_matrix[j, i] += count(x->x==n_pair, [np_1, np_2])
            end
        else
            rule_matrix[i, i] += 1
        end
        init_vec[i] += length(collect(eachmatch(Regex(m_pair), polymer_string.template, overlap=true)))
    end
    return PolymerMatrix(
        monomers,
        monomer_pairs, 
        init_vec, 
        polymer_string.template[begin:begin], 
        polymer_string.template[end:end], 
        rule_matrix
    )
end

apply_matrix!(pm::PolymerMatrix, times)::PolymerMatrix = begin
    pm.template = pm.rules^times * pm.template
    return pm
end

get_max_min_elt(pm::PolymerMatrix)::Tuple{Int, Int} = begin
    mons = Dict(m => 0 for m in pm.monomers)
    for (ei, mp) in zip(pm.template, pm.monomer_pairs)
        mons[mp[begin:begin]] += ei
        mons[mp[end:end]] += ei
    end 
    for m in pm.monomers
        mons[m] += count(x->x==m, [pm.begin_elt, pm.end_elt])
        mons[m] /= 2
    end
    return (min(values(mons)...), max(values(mons)...))
end

parse_input(input::String)::PolymerString = begin
    (template, rules) = split(input, "\n\n")
    rules = String.(split(rules, "\n"))
    return PolymerString(template, Dict(gen_rule.(rules)...))
end

read_input(fname::String)::PolymerString = open(fname, "r") do io
    return parse_input(read(io, String))
end

solution(n::Int)::Int = read_input("inputs/14_1") |>
    gen_matrix_and_initial_state |> 
    y->apply_matrix!(y,n) |> 
    get_max_min_elt |> 
    ((m,M),) -> M - m

println(solution(10))
println(solution(40))
end