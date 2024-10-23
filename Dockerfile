FROM python:3.9-alpine3.14
LABEL maintainer="Ivan Muratov <binakot@gmail.com>"

RUN apk update &&\
    apk add --no-cache \
        build-base linux-headers gcc libc-dev make cmake \
        python3 python3-dev py3-pip

COPY install-nginx-alpine.sh /
RUN sh /install-nginx-alpine.sh

RUN pip install --no-cache-dir uwsgi
COPY uwsgi.ini /etc/uwsgi/

RUN pip install --no-cache-dir supervisor
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY stop-supervisor.sh /etc/supervisor/stop-supervisor.sh
RUN chmod +x /etc/supervisor/stop-supervisor.sh

ENV UWSGI_PLUGIN python3
ENV UWSGI_INI /app/uwsgi.ini
ENV UWSGI_CHEAPER 2
ENV UWSGI_PROCESSES 16
ENV NGINX_MAX_UPLOAD 0
ENV NGINX_WORKER_PROCESSES 1
ENV LISTEN_PORT 80
ENV ALPINEPYTHON python3.9
ENV STATIC_URL /static
ENV STATIC_PATH /app/static
ENV STATIC_INDEX 0

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY ./app /app
WORKDIR /app
ENV PYTHONPATH=/app

COPY entrypoint-base.sh /uwsgi-nginx-entrypoint.sh
RUN chmod +x /uwsgi-nginx-entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start.sh"]
