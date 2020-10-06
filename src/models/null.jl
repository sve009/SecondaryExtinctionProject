# The null model described in our overview paper.
# Returns the matrix.
#
# C = L / S^2
# CS = L / S = the expected number of resources per species. Thus L total.
#
# E[x] = C = 1 / (1 + beta)
# => beta = 1 / C - 1

using Distributions

function null_model(S, C)
    G = fill(0, S, S)
    
    unif = Uniform()

    beta = -1 + (1 / C)
    dist = Beta(1, beta)

    for i in 1:S
        x = rand(dist)
        n = x * S
        for j in 1:n
            v = rand(1:S)
            G[v, i] = 1
        end
    end

    return G
end

