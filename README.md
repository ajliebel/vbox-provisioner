# VBOX Provisioner

Auto provisioning of Linux configured Virtualbox servers that are ready to run Docker and Kuberneties.

```
sudo docker container run -d --name nginx -p 8080:80 -v $(pwd):/usr/share/nginx/html nginx:1.19.3-alpine
```

