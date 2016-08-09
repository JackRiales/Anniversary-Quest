@echo off

SET LOVEDIR="%ProgramFiles%\LOVE"
SET LOVEEXE=%LOVEDIR%\love.exe

SET SRC=game
SET BINDIR=build\win32
SET LOVE=AnniversaryQuest.love
SET EXE=AnniversaryQuest.exe

REM Remove previously built master
if exist %BINDIR% (
   cd %BINDIR%
   DEL %LOVE%
   DEL %EXE%
   DEL *.dll
   cd "../.."
) ELSE (
  mkdir %BINDIR%
)

REM Zip the contents of the source folder
7z a -tzip game.zip -r ./%SRC%/*

REM Rename it to the binary
move game.zip %BINDIR%/%LOVE%

REM Make it into an exe
cd %BINDIR%
copy /b %LOVEEXE% + %LOVE% %EXE%
DEL %BIN%

REM Copy dlls
copy %LOVEDIR%\*.dll *.dll

REM Go back
cd "../.."
