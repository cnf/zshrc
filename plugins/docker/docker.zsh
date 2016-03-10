# docker specific stuff

if (( ! $+commands[docker] ))
then
    return
fi

if [[ -f "$HOME/.config/docker/dockerrc" ]]
then
    . ~/.config/docker/dockerrc
    export DOCKER_HOST
fi

function dockersh() {
    docker run -t -i --rm $@ ubuntu:14.04
}

function dockervolume() {
    echo "docker run --name $1 --volume $2 scratch volume"
    docker run --name $1 --volume $2 scratch volume
}

function docker-rmi-none() {
    docker rmi $(docker images | grep '^<none>' | awk '{print $3}' )
}
