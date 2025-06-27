# this file contains functions to generate nodes on the tree and find the correct partitioning into z sites to which to apply z-site gates
# see TreeStructure.ipynb for more details

function numnodes(z::Integer,gens::Integer)
    if gens==0
        return 1
    else
        return Int64(1+z+z*(z-1)*((z-1)^(gens-1)-1)/(z-2))
    end
end

function graph_nodes(z::Integer,gens::Integer)

    # #make first generation
    pairs=[[1,i] for i in 2:numnodes(z,1)]

    for gen in 2:gens
        count=numnodes(z,gen-1)+1
        for i in (numnodes(z,gen-2)+1):numnodes(z,gen-1)
            for j in 1:(z-1)
                push!(pairs,[i,count])
                count+=1
            end
        end

    end

    return pairs

end

function graph_nodes_2coloring(z::Integer,gens::Integer)

    orange=[[1,i] for i in 2:z]
    green=[[1,z+1]]

    
    for gen in 2:gens
        count=numnodes(z,gen-1)+1
        for i in (numnodes(z,gen-2)+1):numnodes(z,gen-1) #loop around the outside of the tree
            # println(i)
            #check colour of existing bond on i
            if any(i in p for p in orange)
                push!(green,[i,count])
                # println("green",count)
            else
                push!(orange,[i,count])
                # println("orange")
            end
            count+=1

            for j in 1:(z-2) #add z-2 new sites of the same colour
                if gen%2==0
                    push!(green,[i,count])
                    count+=1
                else
                    push!(orange,[i,count])
                    count+=1
                end
            end
            
        end

    end

    return orange,green

end

function merge(pairs)
    zsets=[pairs[1]]
    for pair in pairs[2:end]
        count=0
        for i in 1:length(zsets)
            if !isempty(intersect(zsets[i], pair))
                zsets[i]=union(zsets[i],pair) 
                count+=1
            end
        end
        if count==0
            push!(zsets,pair)
        end
    end
    return zsets
end

function remove_pair(sets)
    return filter(x -> length(x) != 2, sets)
end

#find the sets of nodes on which the gate acts 
function graph_nodes_zsites(z,gens)
    o,g=graph_nodes_2coloring(z,gens)
    om=merge(o)
    gm=merge(g)
    # return om, gm
    return remove_pair(om),remove_pair(gm)
    
end

function find_lc_zsite(z,gens,time)
    #finds the sites in the light cone from the origin at certain time
    trip_lists=graph_nodes_zsites(z,gens)
    lightcone=[1]

    for t in 1:time
        trips=trip_lists[(t-1)%2+1]
        for trip in trips
            if any(x in lightcone for x in trip)
                lightcone=union(lightcone,trip)
            end
        end
    end
    return lightcone
end
