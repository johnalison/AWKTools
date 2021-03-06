# calc3 - infix calculator

NF > 0 {
    # Put  in spaces
    gsub(/[\+,\-,\*,\/,\^]/," & ")
    #gsub(/\-/," - ")
    #gsub(/\+/," + ")
    #gsub(/\-/," - ")
    f=1
    e =expr()
    if (f <= NF) printf("error at %s\n", $f)
    else printf("\t%.8g\n", e)
}

function expr( e) { #term | term [+-] term
    e = term()
    while ($f == "+" || $f == "-")
	e = $(f++) == "+" ? e +term() : e - term()
    return e
}

function term( e) { # factor | factor [*/] factor
    e = factor()
    res = e
    while ($f == "*" || $f == "/" || $f == "^"){
        
        if ($f == "/") {
            f++;
           res = e / factor()
         }
        if ($f == "*") {
            f++;
            res = e * factor()
        }

        if ($f == "^") {
            f++;
            res = e ^ factor()
        }

#if ($(f++) == "^") res = e ^ factor()
    	e = res
    }
#    while ($f == "*" || $f == "/")
#      e = $(f++) == "*" ? e * factor() : e / factor()
    return e
}

function factor( e) { # number : (expr)
    if ($f ~ /^[+-]?([0-9]+[,]?[0-9]*|[,][0-9]+)$/){
	return $(f++)
    } else if ($f == "(") {
	f++
	e = expr()
	if ($(f++) != ")")
	    printf("error: missing ) at %s\n", $f)
	return e
    } else {
	printf("error: expected number or ( at %s\n", $f)
	return 0
    }
}

