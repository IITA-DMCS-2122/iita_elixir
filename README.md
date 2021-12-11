# iita_elixir
Project for IITA 2021 2022

## Installation DB
create image
```sh
$ docker build -t <imagename> ./db
```
run container
```sh
$  docker run --name <containername> -p 5432:5432 <imagename>
```
