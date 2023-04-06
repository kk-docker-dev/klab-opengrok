# OpenGrok source code cross reference in docker

### Pull image
    docker pull kribakarans/opengrok:latest

### Run OpenGrok server
    docker run -d --name opengrok -p 9595:8080 -v <host-projects-path>:/opengrok/src/ kribakarans/opengrok

### Index cross reference
	docker exec -it opengrok bash -c index-xrefs

### Explore projects
    Visit http://localhost:9595/source to explore the projects

### Manage Docker image
**Build and Push AMD64 Image**
```
sudo docker build -t kribakarans/opengrok:amd64 .
sudo docker push kribakarans/opengrok:amd64
```
**Build and Push ARM64 Image**
```
sudo docker build -t kribakarans/opengrok:arm64 .
sudo docker push kribakarans/opengrok:arm64
```

**Create and Push Manifest**
```
sudo docker manifest rm kribakarans/opengrok:latest
sudo docker manifest create kribakarans/opengrok:latest kribakarans/opengrok:amd64 kribakarans/opengrok:arm64
sudo docker push kribakarans/opengrok:amd64
```
