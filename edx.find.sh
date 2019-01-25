#!/bin/bash
#---------------------------------------------------------
# written by: Lawrence McDaniel
#
# date:       oct-2018
#
# usage:      It takes two or three args.
#             1: the file spec you want to search in like *.html or *.css.
#             2: the string you want to grep in the files found using the search spec.
#                Try "calc" to find files that may relate to the calculator.
#             3: the starting directory from which you want to start your search.
#                If you don't provide one, it uses '/edx/app/edxapp/edx-platform/'
#
# warning:  Surround your first argument with quotes.
#           Surround your second argument with quotes if it contains any spaces.
#
#---------------------------------------------------------

if [ $# == 3 ]; then
    echo "Searching " $3
    find $3 -iname "$1" -exec grep -liH "$2" {} \;
elif [ $# == 2 ]; then
    echo "Searching /edx/app/edxapp/edx-platform/lms"
    find /edx/app/edxapp/edx-platform/ -iname "$1" -exec grep -liH "$2" {} \;
else
    echo "Two arguments are required. First the file spec (e.g. '*.html') then the string to grep in the files. The third optional argument specifies the directory in which to start the search."
    exit 1
fi
