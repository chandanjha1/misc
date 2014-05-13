All folders (AIproject, BUILDS, PT-base, Ressources) need to be placed in C:\PT-wininstall

##########
STRUCTURE:
##########

- "AIproject\setup.aip" is a Project file for "Advanced Installed" (Architect) 10.8

- "BUILDS" (to create) is used to store compiled .exe installer

- "PT-base" (to create) needs to contain the files from Popcorn-Time 0.3-dev (and imported in AI)

- "Ressources" contains : images, icons and "dictionaries" folder containing .ail file for translations


##########
TRANSLATE:
##########
You need to add XML (.ail) files to "Ressources\dictionaries", containing the translated strings. 
Then, in AI, add the language you want in "Languages", then laod the .ail dictionnary in "Dictionaries".

##########
Credits : 
##########
MrVaykadji (installer + french/dutch)
SrPatinhas (portuguese)