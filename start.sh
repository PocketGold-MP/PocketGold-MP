#!/bin/bash
DIR="$(cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "$DIR"

while getopts "p:f:l" OPTION 2> /dev/null; do
	case ${OPTION} in
		p)
			PHP_BINARY="$OPTARG"
			;;
		f)
			POCKETMINE_FILE="$OPTARG"
			;;
		l)
			DO_LOOP="yes"
			;;
		\?)
			break
			;;
	esac
done

if [ "$PHP_BINARY" == "" ]; then
	if [ -f ./bin/php7/bin/php ]; then
		export PHPRC=""
		PHP_BINARY="./bin/php7/bin/php"
	elif [[ ! -z $(type php) ]]; then
		PHP_BINARY=$(type -p php)
	else
		echo "Konnte kein funktionierendes PHP 7-Binary finden"
		exit 1
	fi
fi

if [ "$POCKETMINE_FILE" == "" ]; then
	if [ -f ./src/pocketmine/PocketGold.php ]; then
		POCKETMINE_FILE="./src/pocketmine/PocketGold.php"
	else
		echo "PocketGold-MP.phar nicht gefunden"
		echo "Support: https://discord.gg/ve5CpwW"
		exit 1
	fi
fi

LOOPS=0

set +e

if [ "$DO_LOOP" == "yes" ]; then
	while true; do
		if [ ${LOOPS} -gt 0 ]; then
			echo "Restarted $LOOPS times"
		fi
		"$PHP_BINARY" "$POCKETMINE_FILE" $@
		echo "Drücken Sie jetzt STRG + C, um die Schleife zu verlassen. Warten Sie andernfalls 5 Sekunden, bis der Server neu gestartet wurde."
		echo ""
		sleep 5
		((LOOPS++))
	done
else
	exec "$PHP_BINARY" "$POCKETMINE_FILE" $@
fi