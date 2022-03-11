#!/usr/bin/awk -f
BEGIN{ 
    #conjunction = "[ ]+[c|C]ant|[ ]*dont|[ ]*arent|[ ]*its"
    conjunction = "^cant|^dont|^arent"
}

f != FILENAME { print "Reading", FILENAME; f=FILENAME}

{  checkDoubleWords() }

#/[ ]+[c|C]ant|[ ]*dont|[ ]*arent|[ ]*its/ { printError("- conjunction error" ) }

{
    for(i=1; i<=NF; i++) {
	# check for double words
	if(tolower($i) ~ conjunction){
	    printError("- conjunction error " $i)
	}
    }
}

/\.\./ { printError("- double period" ) }

/refereed/ { printError("- Do you really mean to use refereed?") }

/;$/ { printError("- Sentence ends in a ';'") }

/;[ ]*[A-Z]/ { printError("- Capital after a semi-colin") }

# TO DO
# ; followed by a capital letter


function checkDoubleWords() {
    for(i=2; i<=NF; i++) {
	# check for double words
	if(tolower($i) == tolower($(i-1)) ){
	    if(match($i,"&") || match($i,"}") ) continue;
	    printError("- double '" $i "' at position " i)
	}
    }
}


function printError(errorString){
    #print ""
    print errorString  " line", FNR
    print "\t >", $0
    #print ""

}
