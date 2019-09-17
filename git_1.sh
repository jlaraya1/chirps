#!/bin/bash
cd /home/jlaraya/chirps_data/code
ls

#Tutorial:  https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository

git init  #This creates a new subdirectory named .git that contains all of your necessary repository files — a Git repository skeleton. At this point, nothing in your project is tracked yet.


#If you want to start version-controlling existing files (as opposed to an empty directory), you should probably begin tracking those files and do an initial commit. You can accomplish that with a few git add commands that specify the files you want to track, followed by a git commit:

git add *.R
git add *.sh
git commit -m 'initial project version'

#The main tool you use to determine which files are in which state is the git status command. If you run this command directly after a clone, you should see something like this:
git status

git add LEAME
git add LEAME.pdf

#While the git status output is pretty comprehensive, it’s also quite wordy. Git also has a short status flag so you can see your changes in a more compact way. If you run git status -s or git status --short you get a far more simplified output from the command:
git status -s

#if you want to know exactly what you changed, not just which files were changed — you can use the git diff command:

git diff

#  THESE COMMANDS ARE VERY IMPORTANT, RUN THESE ONES FIRST!!!
#  First you have to do an initial commit and this will move the files from your computer to github
#  Here you will also be asked the loggin and password

git commit -m "initial commit"
git push origin master






















