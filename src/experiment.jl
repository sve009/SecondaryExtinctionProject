# Main experiment file. Here we need to actually run all the
# code and make the graphs.

include("models/cascade.jl")
include("models/generalizedcascade.jl")
include("models/niche.jl")
include("models/nestedhierarchy.jl")
include("models/null.jl")

using Plots

# data: 4 x 4 x 3 x 5
#     : #species x connectance x method x model
#     1 = niche
#     2 = gen cascade
#     3 = null
#     4 = cascade
#     5 = nested hierarchy

function experiment()
    S = [25, 50, 100, 200]
    Cs = [.05, .10, .15, .30]
    method = [most_connected_removal, least_connected_removal, rand_removal]

    results = fill(0.0, 4, 4, 3, 5)

    for i in 1:4
        for j in 1:4
            for k in 1:3
                accum = fill(0.00, 5)
                for l in 1:10
                    s = S[i]
                    c = Cs[j]
                    m = method[k]

                    graphs = []

                    push!(graphs, niche_model(s, c))
                    push!(graphs, generalized_cascade_model(s, c))
                    push!(graphs, null_model(s, c))
                    push!(graphs, cascade_model(s, c))
                    push!(graphs, nested_hierarchy_model(s, c))

                    for index in 1:5
                        @show accum[index] = accum[index] + find_robustness(graphs[index], m)
                    end
                end
                for index in 1:5
                    results[i, j, k, index] = accum[index] / 10
                end
            end
        end
    end

    return results
end

function find_robustness(g, m)
    iterations = 0

    S = size(g, 1)
    species = fill(1, S)

    while sum(species) / S > .50
        iterations += 1

        x = m(g, species)

        remove_species(g, species, x)
    end
    
    return iterations / S
end

function remove_species(g, species, x)
    S = size(g, 1)
    
    species[x] = 0
    for i in 1:S
        if g[x, i] == 1
            g[x, i] = 0
            if col_sum(g, i) == 0
                remove_species(g, species, i)
            end
        end
    end
end

function col_sum(g, i)
    accum = 0
    for j in 1:size(g, 2)
        accum += g[j, i] 
    end
    return accum
end

# Removal measures

function rand_removal(g, s)
    x = rand(1:length(s))
    while s[x] == 0
        x = rand(1:length(s))
    end

    return x
end

function most_connected_removal(g, s)
    sums = []
    for i in 1:length(s)
        accum = 0
        for j in 1:length(s)
            accum += g[i, j]
        end
        push!(sums, accum)
    end

    max = 0
    index = 1

    for i in 1:length(sums)
        n = sums[i]
        if n > max && s[i] == 1
            max = n
            index = i
        end
    end

    return index
end

function least_connected_removal(g, s)
    sums = []
    for i in 1:length(s)
        accum = 0
        for j in 1:length(s)
            accum += g[i, j]
        end
        push!(sums, accum)
    end

    index = 1
    while s[index] == 0
        index += 1
    end

    min = sums[index]

    for i in index:length(sums)
        n = sums[i]
        if n < min && s[i] == 1
            min = n
            index = i
        end
    end

    return index
end



