FROM python:3.8.5-alpine3.12

RUN apk add --no-cache mysql
RUN addgroup mysql mysql

RUN apk add gcc musl-dev python3-dev mariadb-dev

RUN mkdir /usr/app
WORKDIR /usr/app
COPY ./requirements.txt .

RUN pip install -U wheel
RUN pip install --upgrade setuptools
RUN pip install -r requirements.txt

VOLUME [ "/var/lib/mysql" ]

ENV PYTHONUNBUFFERED 1

EXPOSE 3306

COPY . .