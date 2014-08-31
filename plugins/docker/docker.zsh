# docker specific stuff

if (( ! $+commands[docker] ))
then
    return
fi

if [[ -f "$HOME/.config/docker/dockerrc" ]]
then
    . ~/.config/docker/dockerrc
    export DOCKER_HOST
    echo "loading docker"
    echo $DOCKER_HOST
fi

function dockersh() {
    docker run -t -i --rm $@ ubuntu
}

function docker-rmi-none() {
    docker rmi $(docker images | grep '^<none>' | awk '{print $3}' )
}
