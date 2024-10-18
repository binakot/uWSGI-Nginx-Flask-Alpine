FROM python:3.9-alpine3.13
LABEL maintainer="Ivan Muratov <binakot@gmail.com>"

RUN apk update
RUN apk add --no-cache gcc libc-dev linux-headers

COPY install-nginx-alpine.sh /
RUN sh /install-nginx-alpine.sh

RUN apk add --no-cache uwsgi-python3
COPY uwsgi.ini /etc/uwsgi/

RUN apk add --no-cache supervisor
COPY supervisord-alpine.ini /etc/supervisor.d/supervisord.ini
COPY stop-supervisor.sh /etc/supervisor/stop-supervisor.sh
RUN chmod +x /etc/supervisor/stop-supervisor.sh

COPY entrypoint-base.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV UWSGI_PLUGIN python3
ENV UWSGI_INI /app/uwsgi.ini
ENV UWSGI_CHEAPER 2
ENV UWSGI_PROCESSES 16
ENV NGINX_MAX_UPLOAD 0
ENV NGINX_WORKER_PROCESSES 1
ENV LISTEN_PORT 80
ENV ALPINEPYTHON python3.9

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

ENV STATIC_URL /static
ENV STATIC_PATH /app/static
ENV STATIC_INDEX 0

COPY ./app /app
WORKDIR /app
ENV PYTHONPATH=/app

RUN mv /entrypoint.sh /uwsgi-nginx-entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start.sh"]
