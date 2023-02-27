#!/bin/bash
#
#       AUTHOR - Raman Sailopal
#
#       Script to clear older images from remote Docker repo
#
#       Takes one parameter and this is the number of the most recent repos to retain.
#
#       First gets a list of all repos/tags and then pulls the most recent locally. The remote registry container is then stopped, the images cleared and then restarted before the local images are pushed back to the repo.
#
if [[ "$1" == "" ]]
then
        echo "Enter the number of images you want to keep for each repo"
        exit 1
fi
if [[ "$2" == "" ]]
then
        echo "Enter the address the local network repo"
        exit 1
fi
if [[ "$3" == "" ]]
then
        echo "Enter path of the registry container persistent storage"
        exit 1
fi

IMGLIST=$(find "$3" -maxdepth 9 -regex "^.*/_manifests/tags/[0-9].*" |awk -F "/" -v keep=$1 ' { imags[$9][$NF]="" } END { PROCINFO["sorted_in"]="@ind_num_desc";for (i in imags) {  cnt=0;for ( j in imags[i] ) {  cnt++; if (cnt<keep+1) { print i":"j }  } } }')
echo -e "\nPulling most $1 recent images to the local registry\n"
echo "$IMGLIST" | while read img
do
    docker pull "$2/$img"
done
echo -e "\nRestarting and clearing Docker registry container\n"
docker stop registry
rm -Rf "$3/*"
docker start registry
echo -e "\nPushing $1 most recent images to the remote registry\n"
echo "$IMGLIST" | while read img
do
    docker push "$2/$img"
done
echo -e "\nRemoving local images\n"
echo "$IMGLIST" | while read img
do
    docker rmi "$2/$img"
done
