#! /bin/bash

function testPresence {
	MYCMD=$1
	NEEDLE=$2
	TITLE=$3

	echo ""
	echo "========== Testing $3"
	echo "   $MYCMD"

	RES=$($MYCMD 2>&1)
	RV=$?

	RES="${RES}-RETVAL:${RV}"

	#echo $RES

	if echo "$RES" | grep "$NEEDLE"; then
		echo "✅ OK"
	else 
		echo "❌ KO: $NEEDLE not found"
		echo ""
		echo "$RES"
		echo ""
		exit 1
	fi

}


CLJ="./examples/clj"
CLJS="./examples/cljs-planck"



#
# custom messages
#
SCRIPT="helpgen:"
CMD="$CLJ/helpgen.clj"
testPresence "$CMD echo -?" \
	"====== SPECIFIC SUBCMD HELP CONFIG: " "$SCRIPT subcommand"

testPresence "$CMD -?" \
	"====== GENERIC 'global' HELP CONFIG: " "$SCRIPT main"





#
# CLJ - Help for subcommands (#110)
#
SCRIPT="toycalc-nested CLJ:"
CMD="$CLJ/toycalc-nested.clj"

testPresence "$CMD" \
     "toycalc - A command-line" "No params"

testPresence "$CMD --help" \
     "toycalc - A command-line" "No params just help"


testPresence "$CMD --base 16 add  --a 1 --b 26" \
     "1b" "Add with base"

testPresence "$CMD --base 16 subc sub  --a 16 --b 3" \
     "d" "sub with base"

testPresence "$CMD --base 16 subc --scale 2 sub --a 16 --b 3" \
     "1a" "Sub with scale and base"

testPresence "$CMD  subc  --scale 2 sub --a 16 --b 3" \
     "26" "Sub scale, no base"

testPresence "$CMD  subc sub --help" \
     "Parameter A to subtract from" "Help subc sub --help"

testPresence "$CMD  subc --help " \
     "toycalc subc - Subtracts" "Help: subc --help "

testPresence "$CMD  subc " \
     "toycalc subc - Subtracts" "Help: subc"




#
# CLJ - No subcommand (#98)
#
SCRIPT="toycalc-nosub CLJ:"
CMD="$CLJ/toycalc-nosub.clj"
testPresence "$CMD --a 10 --b 7 " \
	"17" "No subcommand"



#
# toycalc  - Clojure
#
SCRIPT="toycalc CLJ:"
CMD="$CLJ/toycalc.clj"
testPresence "$CMD -?" \
	"Adds two numbers together" "$SCRIPT no parms"

testPresence "$CMD add -?" \
	"First addendum" "$SCRIPT add help"

testPresence "$CMD --base 16 add -a 1 -b 254" \
	"ff" "$SCRIPT hex add"

export AA=10
testPresence "$CMD add -b 20" \
	"30" "$SCRIPT add with environment"

#
# toycalc  - ClojureScript
#
SCRIPT="toycalc CLJS:"
CMD="$CLJS/toycalc.cljs"
testPresence "$CMD -?" \
	"Adds two numbers together" "$SCRIPT no parms"

testPresence "$CMD add -?" \
	"First addendum" "$SCRIPT add help"

testPresence "$CMD --base 16 add -a 1 -b 254" \
	"ff" "$SCRIPT hex add"

export AA=10
testPresence "$CMD add -b 20" \
	"30" "$SCRIPT add with environment"





#
# toycalc-spec CLJ
#
SCRIPT="toycalc-spec:"
CMD="$CLJ/toycalc-spec.clj"
testPresence "$CMD add -a 10 -b 20" \
	"toycalc/ODD-SMALL" "$SCRIPT A must be odd"


#
# toycalc-spec CLJS
#
SCRIPT="toycalc-spec CLJS:"
CMD="$CLJS/toycalc-spec.cljs"
testPresence "$CMD add -a 10 -b 20" \
	"toycalc-spec/ODD-SMALL" "$SCRIPT A must be odd"


#
# noparms: no parameters and no global config
#
SCRIPT="noparms:"
CMD="$CLJ/noparms.clj"
testPresence "$CMD hi" \
	"Hi man" "$SCRIPT plain"


#
# shutdown hook
#
SCRIPT="shutdown:"
CMD="$CLJ/shutdown.clj"
testPresence "$CMD add -a 10 -b 20" \
	"Shutdown called" "$SCRIPT plain"



#
# sets
#
SCRIPT="sets:"
CMD="$CLJ/sets.clj"
testPresence "$CMD --mode FTP prn --set-str bah" \
	":set-str bah" "$SCRIPT all-ok"

testPresence "$CMD --mode FTP prn --set-str bahl" \
	"Did you mean 'bah'" "$SCRIPT wrong"


SCRIPT="sets CLJS:"
CMD="$CLJS/sets.cljs"
testPresence "$CMD --mode FTP prn --set-str bah" \
	":set-str bah" "$SCRIPT all-ok"

testPresence "$CMD --mode FTP prn --set-str bahl" \
	"Did you mean 'bah'" "$SCRIPT wrong"


#
# wrong-parm
#
SCRIPT="wrong-parm-bug67:"
CMD="$CLJ/wrong-parm-bug67.clj"
testPresence "$CMD" \
	":deadzebra - Aborting" "$SCRIPT Wrong parm type"


#
# CLJS - read file
#
SCRIPT="CLJS read file:"
CMD="$CLJS/read-file.cljs"
DATA="$CLJS/data"
testPresence "$CMD p --edn $DATA/edn-example.edn" \
	":proxy-port" "$SCRIPT EDN"

testPresence "$CMD p --json $DATA/json-example.json" \
	"10021-3100" "$SCRIPT JSON"


testPresence "$CMD p --text $DATA/multiline-text.txt" \
	":text \"The" "$SCRIPT text"

testPresence "$CMD p --lines $DATA/multiline-text.txt" \
	":lines .\"The" "$SCRIPT lines"

# How do we test HTTP requests, as HTTPS does not  work?


#
# CLJS - Return values
#
SCRIPT="exit-status CLJS:"
CMD="$CLJS/exit-status.cljs"
testPresence "$CMD exit --mode ONE " \
	"RETVAL:1" "$SCRIPT exit 1"

testPresence "$CMD exit --mode NONE " \
	"RETVAL:0" "$SCRIPT exit 0"

testPresence "$CMD exit --mode ERROR " \
	"RETVAL:255" "$SCRIPT exit -1"

#
# CLJ - Deferreed values
#
SCRIPT="jvm-promise-bug84 CLJ:"
CMD="$CLJ/jvm-promise-bug84.clj"
testPresence "$CMD promise " \
	"RETVAL:1" "$SCRIPT exit 1"

testPresence "$CMD future " \
	"RETVAL:2" "$SCRIPT exit 2"

testPresence "$CMD async " \
	"RETVAL:3" "$SCRIPT exit 3"






# bash -c './exit-status.cljs exit --mode ONE ||  echo "xxx $?"'
# bash -c './exit-status.cljs exit --mode ERROR ||  echo "xxx $?"'

