#!/usr/bin/env fish

# Define the top-level file and the target subdirectory
set source "/home/dismint/docmint/template.typ"
set biology "/home/dismint/docmint/biology"
set religion "/home/dismint/docmint/religion"
set compilers "/home/dismint/docmint/compilers"
set security "/home/dismint/docmint/security"
set multicore "/home/dismint/docmint/multicore"
set networks "/home/dismint/docmint/networks"
set linear "/home/dismint/docmint/linear"
set comptheory "/home/dismint/docmint/comptheory"

# Create the symbolic link in the target subdirectory
ln -s $source $biology/(basename $source)
ln -s $source $religion/(basename $source)
ln -s $source $compilers/(basename $source)
ln -s $source $security/(basename $source)
ln -s $source $multicore/(basename $source)
ln -s $source $networks/(basename $source)
ln -s $source $linear/(basename $source)
ln -s $source $comptheory/(basename $source)

echo -e "\n== finished linking template.typ =="
