using Random, Distributions

# E[x] = 2C
# E[n] = .5
# E[L] = .5 * 2C = C
# Expected proportion of edges should be C
# Procedure
#   generalized_cascade_model
# Parameters
#   S, an integer
#   C, a float
# Purpose
#   Generates the adjacency matrix of a generalized cascade model food web
# Produces
#   G, a S x S matrix
# Preconditions
#   S > 0
#   0 < C < 1
# Postconditions
#   none 

function generalized_cascade_model(S, C)
    G = fill(0, S, S)
    unif = Uniform()
    niches = [rand(unif) for i=1:S]

    beta = 1 / (2 * C) - 1
    dist = Beta(1, beta)

    for i in 1:S
        n = niches[i]
        x = rand(dist) # E[x] = 2C

        for j in 1:length(niches)
            if niches[j] <= n && rand(unif) <= x # Expected less is .5 * S. 
                G[j, i] = 1
            end
        end
    end
    return G
end
