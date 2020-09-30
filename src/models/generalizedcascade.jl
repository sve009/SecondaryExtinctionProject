using Random, Distributions

function generalized_cascade_model(S, C)
    G = fill(0, S, S)
    unif = Uniform()
    niches = [rand(unif) for i=1:S]

    beta = 1 / (2 * C) - 1
    dist = Beta(1, beta)

    for i in 1:S
        n = niches[i]
        x = rand(dist)
    end
    return G
end
