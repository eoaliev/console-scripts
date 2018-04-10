alias docker-start='docker ps -q | xargs docker kill 2>/dev/null || true &&\
docker-compose pull &&\
docker-compose up -d &&\
docker-compose exec --user phpfpm phpfpm bash\
'

alias docker-restart='docker ps -q | xargs docker kill 2>/dev/null || true &&\
docker-compose up -d &&\
docker-compose exec --user phpfpm phpfpm bash\
'

# Git pull support repository
# gitPullSupport www
# gitPullSupport public_html
function gitPullSupport() {
    git fetch origin master
    git merge origin/master
    cd ${1:-'www'}/bitrix
    git fetch origin bitrix
    git merge origin/bitrix
    cd ../..
}
