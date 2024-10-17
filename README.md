# Python uWSGI Nginx Flask Alpine Docker Image

https://hub.docker.com/r/tiangolo/uwsgi-nginx-flask deprecated Alpine-based image since Python3.8.
(https://github.com/tiangolo/uwsgi-nginx-flask-docker/pull/345)

But I need it ;)

---

```bash
$ docker build -t binakot/uwsgi-nginx-flask:python3.8-alpine .
$ docker run --name python-app -p 80:80 -d binakot/uwsgi-nginx-flask:python3.8-alpine
$ curl localhost
```
