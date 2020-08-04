# Django + MySQL + Docker

[Django](https://www.djangoproject.com/) - v3.1

[MySQL](https://www.mysql.com/) - v8+

[Docker](https://www.docker.com/community-edition)

Define the project components

we need to create a `Dockerfile`, a Python dependencies file `requirements.txt`, and a `docker-compose.yml` file.

1. Create an empty project directory.

2. Create a `requirements.txt` in your project directory and save.

```text
Django==3.1
mysqlclient==2.0.1
```

3. Create a new file called `Dockerfile` in project directory and save.

```dockerfile
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
```

4. Create a file called `docker-compose.yml` in project directory and save.

```yml
version: '3.1'

services:
    db:
        image: mysql
        restart: always
        command: --default-authentication-plugin=mysql_native_password
        environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: djangoApp
        MYSQL_USER: app
        MYSQL_PASSWORD: app
    web:
        build: .
        command: python3 manage.py runserver 0.0.0.0:8000
        depends_on:
        - db
        volumes:
        - .:/usr/app
        ports:
        - "8000:8000"
```

This file defines two services `db` and `web`.

5. Run `docker-compose up --build` ‘up with build’

6. Create a Django project

```bash
docker-compose run web django-admin.py startproject composeexample .
```
`web` docker container image service. `django-admin.py startproject composeexample .` create django project. `composeexample` project name.

7. Connect the database
    In this section, we set up the database connection for Django.

    1. In project directory, edit the `composeexample/settings.py` file.


    2. Replace the `DATABASES = ...` with the following:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'djangoApp',
        'USER': 'app',
        'PASSWORD': 'app',
        'HOST': 'db',
        'PORT': '3306',
    }
}
```

At this point, Django app should be running at port `8000` on your Docker host. On Docker for Mac and Docker for Windows, go to `http://localhost:8000` on a web browser to see the Django welcome page.

Stop the application by typing `Ctrl-C` in the same shell in where you started it:

8. Migration of database

```bash
docker-compose run web python manage.py migrate
```

9. Create Super User

```bash
docker-compose run web python manage.py createsuperuser
```

#### Shell

```bash
docker-compose run web python manage.py shell
```

## Add `phpmyadmin` service

Add Service in `docker-compose.yml` 

```yml
# other service
phpmyadmin:
    image: phpmyadmin/phpmyadmin
    environment:
      - PMA_ARBITRARY=1
    restart: always
    ports:
      - 8082:80
    volumes:
      - /sessions
```
Run `docker-compose build` build phpadmin service

Run `docker-compose up` for up all service
On the port :8082 (http://localhost:8082/)

Enter Details: 
- Server: db
- User name: app
- Password: app