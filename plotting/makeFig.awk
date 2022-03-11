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
    x[++nx] = $1
    if(NF > 1)
	y[++ny] = $2
}



END {

    if(ny && ny != nx){
	printf("ERROR differnet number of x and y points: %s vs %s \n", nx, ny)
	exit
    }

    outputDataLines = ""
    
    # Write the data
    outputDataLines = outputDataLines sprintf("x = [")
    for (i=1; i<=nx; i++){
	outputDataLines = outputDataLines sprintf( x[i] ",\n")
    }
    outputDataLines = outputDataLines sprintf("] \n")

    
    # Write the data
    outputDataLines = outputDataLines sprintf("y = [")
    for (i=1; i<=ny; i++){
	outputDataLines = outputDataLines sprintf( y[i] ",\n")
    }
    outputDataLines = outputDataLines sprintf("] \n")

    if(!plotName) plotName = "outputFig"
    
    print outputDataLines > (plotName "Data.py")
    
    # Write the python
    outputLines = ""
    
    # Header
    pyLines = "import numpy as np \n"		\
	"import matplotlib \n"			\
	"import matplotlib.pyplot as plt \n"	
    outputLines = outputLines sprintf(pyLines)


    pyLines = "from %sData import x, y \n"
    outputLines = outputLines sprintf(pyLines, plotName)
    
    # Histogram
    pyLines = "fig, ax = plt.subplots(1) \n"	
    outputLines = outputLines sprintf(pyLines)
    
    outputLines = outputLines sprintf("# ny is %s", ny)
    outputLines = outputLines sprintf("\n")

    # Do scatter or hist
    if(ny){
	pyLines = "plt.scatter(x, y) \n"
	outputLines = outputLines sprintf(pyLines)
    }else{
	pyLines = "plt.hist(x ,histtype='%s',linewidth=%s,color='%s' %s) \n"	
	if(nbins){
	    binsText = sprintf(", bins=np.linspace(%s,%s,%s)", xRangeLow, xRangeHigh, nbins)
	}
	outputLines = outputLines sprintf(pyLines, histtype, linewidth, color, binsText)
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

    outputLines = outputLines sprintf("plt.savefig('" plotName ".pdf') \n")

    print outputLines > (plotName ".py")    
    system("python " plotName ".py")    
}


function stripFirstWord(){
    gsub($1, "", $0);        # Remove first word
    gsub(/^[ \t]/, "", $0);  # Strip leading whiteSpace
    return $0
}
