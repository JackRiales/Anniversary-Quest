#!/bin/bash

NAME="Anniversary Quest.love"

mkdir -p build/linux
cd game
zip -9 -r "tmp.game.love"
mv tmp.game.love ../build/linux/$NAME .
cd ..
