# makeFig: generate script to make pdf plot  
# input:   data [x] will make a histogram
# output:

BEGIN {
    linewidth=3
    color="r"
    histtype="step"
    ylabel = "Entries"
    xlabel = "Value"
}


#
# Get the plot name
#
!plotName {plotName = FILENAME}

#
# Get the dataset name
#
!(FILENAME in datasets) {print "adding datasetNow" FILENAME; datasets[FILENAME] = 1; currentDataset = FILENAME}

/^#/ {
    next
}

/^[x,X][b,B]in/ {
    nbins = $2
    xRangeLow  = $3
    xRangeHigh = $4

    next
}


/^[y,Y][r,R]ange/ {
    yRangeLow  = $2
    yRangeHigh = $3

    next
}

/^[y,Y][l,L]og/ {
    logy = 1
    next
}

/^[x,X][l,L]abel|[x,X][t,T]itle]/ {
    xlabel = stripFirstWord(); next
    next
}

/^[y,Y][l,L]abel|[y,Y][t,T]itle]/ {
    ylabel = stripFirstWord(); next
    next
}



/./ {

    x[currentDataset, ++nx[currentDataset]] = $1
    if(NF > 1)
	y[currentDataset, ++ny[currentDataset]] = $2

}



END {
    #print datasets
    for(dsName in datasets){
	print "Number in dataset" dsName " " nx[dsName]

	if(ny[dsName] && ny[dsName] != nx[dsName]){
	    printf("ERROR differnet number of x and y points: %s vs %s \n", nx[dsName], ny[dsName])
	    printf("\t In dataset %s", dsName)
	    exit
	}

	outputDataLines = ""
    
	# Write the data
	outputDataLines = outputDataLines sprintf("x = [")
	for (i=1; i<=nx[dsName]; i++){
	    outputDataLines = outputDataLines sprintf( x[dsName, i] ",\n")
	}
	outputDataLines = outputDataLines sprintf("] \n")
	
	
	# Write the data
	outputDataLines = outputDataLines sprintf("y = [")
	for (i=1; i<=ny[dsName]; i++){
	    outputDataLines = outputDataLines sprintf( y[dsName, i] ",\n")
	}
	outputDataLines = outputDataLines sprintf("] \n")
	
	if(!plotName) plotName = "outputFig"
	
	print outputDataLines > (dsName "Data.py")
    }
    
    # Write the python
    outputLines = ""
    
    # Header
    pyLines = "import numpy as np \n"		\
	"import matplotlib \n"			\
	"import matplotlib.pyplot as plt \n"	
    outputLines = outputLines sprintf(pyLines)

    #
    #  Import data
    #
    for(dsName in datasets){
	pyLines = "from %sData import x as x_%s \n"
	outputLines = outputLines sprintf(pyLines, dsName, dsName)

	pyLines = "from %sData import y as y_%s \n"
	outputLines = outputLines sprintf(pyLines, dsName, dsName)
    }
    # Histogram
    pyLines = "fig, ax = plt.subplots(1) \n"	
    outputLines = outputLines sprintf(pyLines)
    
    #outputLines = outputLines sprintf("# ny is %s", ny)
    outputLines = outputLines sprintf("\n")

    #
    # Plot data
    #
    # Do scatter or hist
    for(dsName in datasets){
	if(ny[dsName]){
	    pyLines = "plt.scatter(x_%s, y_%s, color='%s', label='%s') \n"
	    outputLines = outputLines sprintf(pyLines, dsName, dsName, getColor(), dsName)
	}else{
	    pyLines = "plt.hist(x ,histtype='%s',linewidth=%s,color='%s' %s) \n"	
	    if(nbins){
		binsText = sprintf(", bins=np.linspace(%s,%s,%s)", xRangeLow, xRangeHigh, nbins)
	    }
	    outputLines = outputLines sprintf(pyLines, histtype, linewidth, color, binsText)
	}
    }


    if(xRangeLow || xRangeHigh){
	pyLines = "plt.xlim(%s, %s) \n"
	outputLines = outputLines sprintf(pyLines, xRangeLow, xRangeHigh)
    }

    
    if(yRangeHigh){
	pyLines = "plt.ylim(%s, %s) \n"
	outputLines = outputLines sprintf(pyLines, yRangeLow, yRangeHigh)
    }

    if(logy){
	pyLines = "plt.yscale('log') \n"
	outputLines = outputLines sprintf(pyLines)
    }
    
    # Labels
    pyLines = "plt.xlabel('%s') \n" \
	"plt.ylabel('%s') \n" 
    outputLines = outputLines sprintf(pyLines,xlabel,ylabel)    

    outputLines = outputLines sprintf("plt.legend() \n")
    outputLines = outputLines sprintf("plt.savefig('" plotName ".pdf') \n")

    print outputLines > (plotName ".py")    
    system("python " plotName ".py")    
}

function getColor(){
    colors[0] = "b"
    colors[1] = "r"
    colors[2] = "k"

    return colors[nCol++]
}

function stripFirstWord(){
    gsub($1, "", $0);        # Remove first word
    gsub(/^[ \t]/, "", $0);  # Strip leading whiteSpace
    return $0
}
