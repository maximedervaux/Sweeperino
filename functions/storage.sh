#!/bin/bash

# Display disk space
display_space() {
    space=$(df -h / | awk 'NR==2 {print $4 " free out of " $2}')
    yad --info --text="Available disk space: $space"
}
