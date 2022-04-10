
The goal of this repo is to provide an alternative setup for stremio, to be able to stream directly in the browser on devices like smartphones and tablets.  

The environment is provided using Docker Compose (docker containers).

- Stremio Server  
The streaming server, handle the file download and streaming to the web interface  

- Stremio Web
Display the stremio interface

Commands  
docker-compose up  
docker-compose build

You can access the web interface via:
- http://locahost:8085 or http://192.168.1.x:8085 (network ip of the computer running this setup)  

The streaming server is on
- http://locahost:11475 or http://192.168.1.x:11475
