@echo off
TITLE PocketGold server software for Minecraft: Bedrock Edition
cd /d %~dp0

if exist bin\php\php.exe (
	set PHPRC=""
	set PHP_BINARY=bin\php\php.exe
) else (
	set PHP_BINARY=php
)

if exist PocketGold-MP.phar (
	set POCKETMINE_FILE=PocketGold-MP.phar
) else (
	if exist src\pocketmine\PocketGold.php (
		set POCKETMINE_FILE=src\pocketmine\PocketGold.php
	) else (
		echo PocketGold-MP.phar wurde nicht gefunden
		pause
		exit 1
	)
)

if exist bin\mintty.exe (
	start "" bin\mintty.exe -o Columns=88 -o Rows=32 -o AllowBlinking=0 -o FontQuality=3 -o Font="Consolas" -o FontHeight=10 -o CursorType=0 -o CursorBlinks=1 -h error -t "PocketMine-MP" -i bin/pocketmine.ico -w max %PHP_BINARY% %POCKETMINE_FILE% --enable-ansi %*
) else (
	REM pause on exitcode != 0 so the user can see what went wrong
	%PHP_BINARY% -c bin\php %POCKETMINE_FILE% %* || pause
)