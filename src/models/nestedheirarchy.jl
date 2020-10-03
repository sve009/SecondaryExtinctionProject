{\rtf1\ansi\ansicpg1252\cocoartf2513
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 using LightGraphs, Distributions, Random\
\
\
\
function nested_heirarchy_model(S, C)\
    \
    G = SimpleDiGraph(S)\
    \
    unif = Uniform()\
    niches = [rand(unif) for i=1:S]\
    niches = sort(niches)\
    \
    beta = 1 / ((1/(2C)) - 1)\
    dist = Beta(1, beta)\
    \
    L = C * S * S\
    links = [rand(dist) * x for x in niches]\
    l_sum = sum(links)\
    \
    con_group = fill(0,S)\
    groups = []\
    \
\
    \
    for pred in 2:S     # Smallest niche species has no prey\
        x = rand(dist)\
        r = min(S-1,links[pred] * L / l_sum)        \
        \
        consumers = []\
        \
        while r > 0     #stage 1 - choose random prey with a smaller niche value\
            possible = [p for p in 1:pred-1]\
            prey = rand(possible)\
            consumers = inneighbors(G,prey)\
            if length(consumers) != 0  # go to stage two when selected prey has a consumer\
                break\
            end\
            add_edge!(G,pred,prey)\
            filter!(p->p!=prey,possible)\
            r -= 1\
        end\
    \
        if r > 0        #stage 2 - choose at random from consumer group of selected prey\
            if con_group[consumers[1]] == 0   # create new consumer group if other consumer doesn't have a group\
                con_group[pred] = length(groups) + 1\
                con_group[consumers[1]] = length(groups) + 1\
                x = outneighbors(G,pred)         \
                push!(groups,append!(x,outneighbors(G,consumers[1])))\
            end\
            con_group[pred] = con_group[consumers[1]]\
            possible = shuffle(groups[con_group[pred]])\
            for prey in possible\
                if r > 0                     # move to stage 3 when no prey are left\
                    add_edge!(G,prey,pred)\
                    r -= 1\
                end\
            end\
        end\
        \
        \
        if r > 0       #stage 3 - choose random from smaller niche with no consumers\
            possible = [p for p in 1:pred-1]\
            filter!(p-> inneighbors(G,p)==0,possible)\
            for prey in shuffle!(possible)\
                if r > 0\
                    add_edge!(G,prey,pred)\
                    r -= 1\
                else\
                    break   # move to stage 4 when no more lesser species have 0 consumers\
                end\
            end\
        end\
        \
        if r > 0         #stage 4 - choose random from larger niche species, highest niche has no predators\
            possible = [p for p in pred:S-1]\
            for prey in shuffle!(possible)\
                if r > 0\
                    add_edge!(G,prey,pred)\
                    if con_group[pred] != 0\
                        x = groups[con_group[pred]]\
                        groups[con_group[pred]] = x\
                    end\
                    r -= 1\
                else\
                    break\
                end   \
            end \
        end\
    end\
    return G\
end}