# Alice's over-engineered z-shell configuration, released in the public domain.
# Primary loader for categories of common and not-so-common shell aliases.

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Load all plugins.
for i in $(ls -b $ZDOTDIR/plugins); do
    clean=$(basename $i)
    load plugins/$clean/$clean
done
