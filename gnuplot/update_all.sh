#!/bin/bash

for file in plot*.gnuplot
do
	gnuplot $file > /dev/null
done
