# Alice's over-engineered z-shell configuration, released in the public domain.
# Primary loader for categories of common and not-so-common shell aliases.

# Load all aliases.
for i in $(ls -b $ZDOTDIR/lib); do
    load lib/$(basename $i .zsh)
done
