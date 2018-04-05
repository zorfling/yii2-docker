# yii2-docker

Yii2 / PHP 7.1 / Apache docker image

Cut down and updated version of [codemix/yii2-dockerbase](https://github.com/codemix/yii2-dockerbase)

## Build

```bash
$ docker build -t <tag> ./
```

## Push

```bash
$ docker push <tag>
```

## Use

There is a built version up on [DockerHub](https://hub.docker.com/r/zorfling/yii2-docker)

```yml
# docker-compose.yml
web:
    image: zorfling/yii2-docker:php7.1-apache
    ports:
        - "8080:80"
    expose:
        - "80"
    volumes:
        - ./:/var/www/html/
```

Then

```bash
$ docker-compose up web -d
```

OR

```bash
# from your Yii root
$ docker run -it -v $PWD:/var/www/html zorfling/yii2-docker:php7.1-apache
```
