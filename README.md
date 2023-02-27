# docker-local-repo

Simple bash script to retain last x number of images for each repo when hosting images on "local" network. Useful in a devops CI/CD context where new images are being deployed with a high frequency and there is a potential for "rollbacks"

# Pre-requisites

The script assumes that a "local network" Docker registry container is already running on the same machine as the machine running the main repoclean.sh script. Details of running a local Docker registry can be found here

https://docs.docker.com/registry/deploying/

= Running the script

**Considerations** - For a large number of repos/images, this script is not an optimal solution.

The script will first pull all repo images to the local Docker repo. It then will stop the container running the registry, remove the mapped persistent storage and restart the container before pushing images back based on the retention index passed. An index of 3 for example will keep the last 3, most recent images for each repo and then delete the other images. Because images are pulled locally as a first stage, it is important to ensure that enough space is availabe to run the script.

To execute the script run:

    ./repoclean 3 "192.168.240.9:5000/Ram" "/var/docker-images"
    
Where 3 is the number of images for each repo to keep, 192.168.140.9:5000/Ram is the address of the registry as well as the name of the user hosting the repo and /var/docker-images is the local registry container persistent storage.



