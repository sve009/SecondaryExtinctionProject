using Random, Distributions

function niche_model(S, C)
    G = fill(0, S, S)

    unif = Uniform()
    niches = [rand(unif) for i=1:S]

    # E[x] = 2C = 1 / (1 + beta) => beta = 1 / 2C - 1
    beta = -1 + 1 / (2 * C)
    dist = Beta(1, beta)

    for i in 1:S
        x = rand(dist)
        r = x * niches[i] # E[r] = .5 * E[x] = C
        c = rand(Uniform(r/2, niches[i]))

        for j in 1:length(niches)
            if niches[j] >= c - (r/2) && niches[j] <= c + (r/2)
                G[j, i] = 1
            end
        end
    end
    return G
end





