using LightGraphs

function test_connectance(model)
    connectances = []
    for i in 0:.05:.30
        for j in 25:5:200
            accum = 0
            for k in 1:1000
                d = DiGraph(model(j, i))
                accum += ne(d) / (nv(d)^2)
            end
            push!(connectances, accum / 1000)
        end
    end
    println("Actual connectances: $connectances")
end



