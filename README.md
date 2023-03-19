# OpenGrok source code cross reference in docker

### Pull image
    docker pull kribakarans/opengrok:latest

### Run OpenGrok server
    docker run -d --name opengrok -p 9595:8080 -v <host-projects-path>:/opengrok/src/ kribakarans/opengrok

### Index cross reference
	docker exec -it opengrok bash -c index-xrefs 

### Explore projects
    Visit http://localhost:9595/source to explore the projects
