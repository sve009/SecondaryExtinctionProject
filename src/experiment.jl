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

# Procedure
#   robustness_experiment
# Parameters
#  none
# Purpose
#   calculates and plots robustness for each combination of S, C, model, and ordering
# Produces
#   results, an array of plots
# Preconditions
#   none
# Postconditions
#   none
function robustness_experiment()
    S = [25, 50, 100, 200]
    Cs = [.05, .10, .15, .30]
    method = [most_connected_removal, least_connected_removal, rand_removal]

    results = fill(0.0, 4, 4, 3, 5)

    for i in 1:4
        for j in 1:4
            for k in 1:3
                accum = fill(0.00, 5)
                for l in 1:500
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
                    results[i, j, k, index] = accum[index] / 500
                end
            end
        end
    end

    return results
end

# Procedure
#   web_collapse_experiment
# Parameters
#   none
# Purpose
#   calculates and plots web collapse for each combination of S,C, model, and removal
# Produces
#   results, an array of plots
# Preconditions
#   none
# Postconditions
#   none
function web_collapse_experiment()
    S = [25, 50, 100, 200]
    Cs = [.05, .10, .15, .30]
    method = [most_connected_removal, least_connected_removal, rand_removal]

    results = fill(0.0, 4, 4, 3, 5)

    for i in 1:4
        for j in 1:4
            for k in 1:3
                accum = fill(0.00, 5)
                for l in 1:500
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
                        @show accum[index] = accum[index] + collapse(graphs[index], m)
                    end
                end
                for index in 1:5
                    results[i, j, k, index] = accum[index] / 500 
                end
            end
        end
    end

    return results
end

# Procedure
#   find_robustness
# Parameters
#   g, an array
#   m, a function
# Purpose
#   calculates the robustness of a model and extinction order
# Produces
#   robustness, a float
# Preconditions
#   none
# Postconditions
#   none
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

# Procedure
#   collapse
# Parameters
#   g, an array
#   m, a function
# Purpose
#   determines if a web collapses
# Produces
#   collapse, an int
# Preconditions
#   none
# Postconditions
#   none
function collapse(g, m)
    S = size(g, 1)
    species = fill(1, S)

    while sum(species) / S > .20
        x = m(g, species)

        remove_species(g, species, x)
    end
    
    return sum(species) == 0 ? 1 : 0
end

# Procedure
#   remove_species
# Parameters
#   g, an array
#   species, a list
#   x, an int
# Purpose
#   removes a species connections from a graph
# Produces
#   none
# Preconditions
#   none
# Postconditions
#   row_sum(g, x) == 0
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

# Procedure
#   col_sum
# Parameters
#   g, an array
#   i, an int
# Purpose
#   computes the sum of a column
# Produces
#   accum, an int
# Preconditions
#   none
# Postconditions
#   none
function col_sum(g, i)
    accum = 0
    for j in 1:size(g, 2)
        accum += g[j, i] 
    end
    return accum
end

# Removal measures

# Procedure
#   rand_removal
# Parameters
#   g, an array
#   s, a list
# Purpose
#   removes a random element of s
# Produces
#   x, an int
# Preconditions
#   none
# Postconditions
#   none
function rand_removal(g, s)
    x = rand(1:length(s))
    while s[x] == 0
        x = rand(1:length(s))
    end

    return x
end

# Procedure
#   most_cnnected_removal
# Parameters
#   g, an array
#   s, a list
# Purpose
#   removes the most connected element in g from s
# Produces
#   index, an int
# Preconditions
#   none
# Postconditions
#   none
function most_connected_removal(g, s)
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
    max = sums[index]

    for i in 1:length(sums)
        n = sums[i]
        if n > max && s[i] == 1
            max = n
            index = i
        end
    end

    return index
end

# Procedure
#   least_connected_removal
# Parameters
#   g, an array
#   s, a list
# Purpose
#   removes the least connected element in g from s
# Produces
#   x, an int
# Preconditions
#   none
# Postconditions
#   none
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



