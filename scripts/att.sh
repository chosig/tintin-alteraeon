#!/bin/bash

voice=$(shuf -e -n 1 "crystal" "mike" "rich" "lauren" "claire")

play -t wav -qV0 http://192.20.225.36$(curl -s --data "voice=$voice&txt=$*&speakButton=SPEAK" "http://192.20.225.36/tts/cgi-bin/nph-nvdemo"|grep ".wav"|cut -d\" -f2) norm
