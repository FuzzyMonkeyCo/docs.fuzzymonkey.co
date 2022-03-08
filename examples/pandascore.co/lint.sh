#!/bin/bash -u

set -o pipefail

MONKEY=${MONKEY:-monkey}

(
	echo 42 | \time "$MONKEY" --file newer.star schema --validate-against=#/components/schemas/GameID ;
	"$MONKEY" --file newer.star logs | tail -n1 ;
	echo ;
	echo 42 | \time "$MONKEY" --file newer.star schema --validate-against=#/components/schemas/GameID ;
	"$MONKEY" --file newer.star logs | tail -n1 ;
	echo ;
	echo 42 | \time "$MONKEY" --file newer.star schema --validate-against=#/components/schemas/GameID ;
	"$MONKEY" --file newer.star logs | tail -n1 ;
	echo ;

	echo === ;

	echo ;
	echo 42 | \time "$MONKEY" --file bigger.star schema --validate-against=#/components/schemas/GameID ;
	"$MONKEY" --file bigger.star logs | tail -n1 ;
	echo ;
	echo 42 | \time "$MONKEY" --file bigger.star schema --validate-against=#/components/schemas/GameID ;
	"$MONKEY" --file bigger.star logs | tail -n1 ;
	echo ;
	echo 42 | \time "$MONKEY" --file bigger.star schema --validate-against=#/components/schemas/GameID ;
	"$MONKEY" --file bigger.star logs | tail -n1 ;
) 2>&1
