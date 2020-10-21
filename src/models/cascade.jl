function cascade_model(S, C)
  
    G = fill(0, S, S)
    niche = sort(rand(S))
    p = 2 * C * S / (S-1)
    
    for i in 1:S
        for j in i+1:S
            if rand() < p
                G[i,j] = 1
            end
        end
    end
    return G
end
