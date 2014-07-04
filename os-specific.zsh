if [[ `uname` == 'Darwin' ]]
then
    load osx
fi

if [[ `uname` == 'Linux' ]]
then
    alias open="xdg-open &> /dev/null"
fi
