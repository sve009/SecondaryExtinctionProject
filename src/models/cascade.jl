# Procedure
#   cascade_model
# Parameters
#   S, an integer
#   C, a float
# Purpose
#   Generates the adjacency matrix of a cascade model food web
# Produces
#   G, a S x S matrix
# Preconditions
#   S > 0
#   0 < C < 1
# Postconditions
#   none

function cascade_model(S, C)
  
    G = fill(0, S, S)
  
    niche = sort(rand(S)) #order randomly assigned niche values
  
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
