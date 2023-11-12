# Docker and Kubernetes hands on practices

This repo contains a couple of basic container ( Docker ) and Kubernetes practices and it's infrastructure creation.

## Containers

## Prepare the environment

Login to the provided VM with a ssh terminal or Azure cloud shell. The VMs are created befor the sesson and deleted after.

hostname: vm<num>.oedevops.site
username: azureadm
pwd: ****

```bash
ssh azureadm@vm0.oedevops.site

azureadm@oe-docker-vm0:~$ 

```

*You can use your own computer as well with internet access. Prerequisites: installed Docker and running docker daemon, clone of this repository, Python 3 installed with Flask module*


## Run an existing application in docker 

You will run an Nginx application in a Docker container.

*Nginx is a lightweight web server that can also be used as a reverse proxy, load balancer.*

```bash
sudo docker run -p 80:80 nginx:1.24.0
```

Try out your Nginx websrever. Use your browser and type the following URL into the addressline:

http://vm0.oedevops.site/

You will see the Nginx welcome page.
Alternatively open another session and use the following command.

```bash
curl vm0.oedevops.site
```

You will see the html source of the Nginx index page.

```bash
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
...
```


Terminate the application, press CTRL-C.

Run the application in detached mode where. You will get back the command prompt right after the container is started.

```bash
sudo docker run -p 80:80 -d nginx:1.24.0
```
The output is the container id
```bash
2b27ba1754915b5e31bd85ed891398fde526831930dca576cbbbb8f2fbed9d77
```

Check your application again as mentioned above. 

Check the docker processes.

```bash
sudo docker ps
```

```bash
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                               NAMES
2b27ba175491   nginx:1.24.0   "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp   vibrant_haibt
```

The Docker names the containers randomly in case you do not provide a name.
vibrant_haibt in this case

If you want to oparate your application you need either the id or the name of the container.
- 2b27ba175491
- vibrant_haibt

Stop and remove your the container.
```bash
sudo docker stop vibrant_haibt
sudo docker rm vibrant_haibt
```

Now start the container with properly named.

```bash
sudo docker run -p 80:80 -d --name mynginx nginx:1.24.0
```

Check the log of your Nginx server.
```bash
sudo docker logs mynginx 
```

Check your application again.
Stop the container.

```bash
sudo docker stop mynginx
```

Check the applkcation, it will not respond.

Restart your containerized application.

```bash
sudo docker start mynginx
```

Stop and remove the container.

```bash
sudo docker stop mynginx
sudo docker rm mynginx
```

### Add a volume to the application

Persisting files you need to add a volume to your container. 
In this example you setup a directory *site* that is used as the root of your web content. 
In this example we just privide the *index.html*, however feel free to extend with your own idea.

Add your own index page to your Nginx server.


```bash
mkdir site
cd site
echo "Hello world!" > index.html
cd ..
```

Start the container.
```bash
sudo docker run -v ~/site:/usr/share/nginx/html -p 80:80 -d --name mynginx nginx:1.24.0
```

Test your Nginx.
```bash
curl vm0.oedevops.site
```


Stop and remove the container.

```bash
sudo docker stop mynginx
sudo docker rm mynginx
```


## Build a docker image from your application

There is a prepared sample Python server application which provides a simple REST webservice interface in the following directory: oe-kubernetes/application/src/
Investigate the code if you would like to.

### Try the application

```bash
python3 oe-kubernetes/application/src/server.py
```
Output of the start.

```bash
 * Serving Flask app 'server'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:8080
 * Running on http://10.0.0.4:8080
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 373-918-871
```

Test your Python REST service
```bash
curl vm0.oedevops.site:8080/book
```
Output
```bash
[
  {
    "author": "Harper Lee",
    "pages": 281,
    "publish_date": "1960-07-11",
    "title": "To Kill a Mockingbird"
  },
  {
    "author": "George Orwell",
    "pages": 328,
    "publish_date": "1949-06-08",
    "title": "1984"
  },
  {
    "author": "F. Scott Fitzgerald",
    "pages": 181,
    "publish_date": "1925-04-10",
    "title": "The Great Gatsby"
  }
]
```

Stop your server with CTRL-C.


### Wrap your app in a container 

Check your Dockerfile

```bash
cat oe-kubernetes/application/Dockerfile
```

Build your image.

```bash
sudo docker build -t bookservice oe-kubernetes/application
```

Run your container app that has just been built.
```bash
sudo docker run -d -p 8080:8080 --name mybookservice bookservice
```
*bookservice* is your image name, the -t is for tagging, the last parameter is the place of the Dockerfile.

Check your application again.
```bash
curl vm0.oedevops.site:8080/book
```

Stop and remove your container.
```bash
sudo docker stop mybookservice
sudo docker rm mybookservice
```
