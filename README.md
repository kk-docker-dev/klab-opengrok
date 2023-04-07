# OpenGrok source code cross reference in docker

### Pull image

    docker pull kribakarans/opengrok:latest

### Run OpenGrok server

    docker run -d --name opengrok -p 9595:8080 -v <host-projects-path>:/opengrok/src/ kribakarans/opengrok

### Adding projects
Add your projects to build xrefs to `host-projects-path`. Ex: `$HOME/Public`.

### Index cross reference

    docker exec -it opengrok bash -c index-xrefs

### Explore projects
Visit http://localhost:9595/source to explore the projects

### Manage Docker image
**Build and push AMD64 image**

    sudo docker build -t kribakarans/opengrok:amd64 .
    sudo docker push kribakarans/opengrok:amd64

**Build and push ARM64 image**

    sudo docker build -t kribakarans/opengrok:arm64 .
    sudo docker push kribakarans/opengrok:arm64

**Create and push manifest**

    sudo docker manifest rm kribakarans/opengrok:latest
    sudo docker manifest create kribakarans/opengrok:latest kribakarans/opengrok:amd64 kribakarans/opengrok:arm64
    sudo docker manifest push kribakarans/opengrok:latest
