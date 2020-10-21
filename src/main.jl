include("experiment.jl")

using Plots
using Plots.PlotMeasures

plotly()

# This function takes a 4 x 4 x 3 x 5 tensor
# and simply turns it into several plots.
# @pre data 4 x 4 x 3 x 5 tensor. pt is max y-axis bound
# @post Plots the data

function plot_data(data, pt)

    S = [25, 50, 100, 200]
    Cs = [.05, .10, .15, .30]

    # Plot set 1: Most connected
    #           : x = connectance

    x = Cs

    models = ["Niche", "Generalized Cascade", "Null", "Cascade", "Nested-Hierarchy"]
    methods = ["Most Connected", "Least Connected", "Random"]

    plots = []

    for k in 1:3
        for i in 1:5
            l = false

            if i == 1
                l = true
            end

            # 25
            y = [data[1, j, k, i] for j = 1:4]

            la = ""
            if i == 1 && k == 1
                la = "25"
            end
            plot(x, y, title="$(models[i]), $(methods[k])", label=la, legend=l, bottom_margin=2mm, titlefontsize=8, ylims=(0.0, pt))
            scatter!(x, y, label="") 

            # 50
            y = [data[2, j, k, i] for j = 1:4]
            la = ""
            if i == 1 && k == 1
                la = "50"
            end
            plot!(x, y, label=la)
            scatter!(x, y, label="") 

            # 100
            y = [data[3, j, k, i] for j = 1:4]
            la = ""
            if i == 1 && k == 1
                la = "100"
            end
            plot!(x, y, label=la)
            scatter!(x, y, label="")
            
            # 200
            y = [data[4, j, k, i] for j = 1:4]
            la = ""
            if i == 1 && k == 1
                la = "200"
            end
            plot!(x, y, label=la)
            p = scatter!(x, y, label="")
            push!(plots, p)
        end
    end

    display(
            plot(
                 plots[1], 
                 plots[2], 
                 plots[3], 
                 plots[4], 
                 plots[5], 
                 plots[6], 
                 plots[7], 
                 plots[8], 
                 plots[9], 
                 plots[10], 
                 plots[11], 
                 plots[12], 
                 plots[13], 
                 plots[14], 
                 plots[15], 
                 layout=(3, 5),
                 size=(1400, 800),
                 legend=true,
                )
           )
end

# Actually runs the experiment.

data1 = robustness_experiment()
plot_data(data1, .60)
data2 = web_collapse_experiment()
plot_data(data2, 1.10)









