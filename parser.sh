
echo "distinctFlag=0" >> potential.modifier

function parseDist {
    flag=0
    shopt -s nocasematch
    while true; do
	case "$1" in
	    "select" ) flag=1; shift ;;
	    "reduced" ) shift ;; # Ignored.
	    "distinct" ) echo "distinctFlag=1" >> potential.modifier ; shift ;;
	    "" | "where" | "where{" ) break ;;
	    * )
		if [[ $flag == 0 ]];
		then shift
		else echo $1; shift
		fi
		;;
	esac
    done
    shopt -u nocasematch
}
function parseBGP {
    flag=0
    shopt -s nocasematch
    while true; do
	case "$1" in
	    "where" | "where{" )
		flag=1
		shift
		;;
	    "{" ) shift ;;
	    "" | "}" ) break ;;
	    * )
		if [[ $flag == 0 ]];
		then shift
		else 
		    # Warn: Strings as objects are currently NOT handled!
		    echo -e $1 $2 $3
		    if [[ $4 == "." ]];
		    then shift 4
		    else shift 3
		    fi
		fi
		;;
	esac
    done
    shopt -u nocasematch
}
function parseModifiers {
    flag=0
    shopt -s nocasematch
    while true; do
	case "$1" in
	    "}" ) flag=1; shift ;;
	    "limit" ) if [[ $flag == 1 ]]; then echo "LIMIT $2"; fi ; shift 2 ;;
	    "offset" ) shift 2 ;; # Ignored.
	    "" ) break ;;
	    * ) if [[ $flag == 1 ]]; then break ; else shift ; fi ;;
	esac
    done
    shopt -u nocasematch
}
function isVar {
    str1=$1
    if [[ ${str1:0:1} == +("?"|"\$") ]] ; 
    then echo 1 ; 
    else echo 0 ;
    fi
}
