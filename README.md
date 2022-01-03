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

## Uruchomienie aplikacji todo

Aby uruchomić aplikację konieczne jest zainstalowanie na swojej maszynie zarówno Elixir-a jak i Phoenix-a, na końcu akapitu umieszczono link co należy zrobić jeśli ktoś jeszcze nie dokonał tej instalacji [How to install elixir with phoenix](https://www.vultr.com/docs/how-to-install-elixir-and-phoenix-framework-on-ubuntu-16-04/)

Jeżeli wszystko zostało zainstalowane pomyślnie, należy przejść do katalogu **todo** w, którym przed pierwszym uruchomieniem należy wykonać polecenie
```
mix ecto.migrate
```
Polecenie dokona migracji, a jeśli ktoś chciałby przeczytać więcej na temat tego polecenia to odsyłam do dokumentacji [ecto.migrate](https://hexdocs.pm/ecto_sql/Mix.Tasks.Ecto.Migrate.html). Istotne jest, aby w bazie danych postgress znajdował się użytkownik **postgres** z hasłem **postgres**. Jeżeli baza danych nie posiada takiego użytkownika konieczne jest zmodyfikowanie danych użytkownika w bazie danych w pliku todo/config/dev.exs na takie jakie posiadamy lokalnie.

Jeśli migracja wykona się pomyślnie, w bazie danych powinna stworzyć się tabel items. Następnie można wykonać polecenie
```
mix.phx server
```
, które powinno uruchomić aplikację

W razie wystąpienia błędu związangeo z brakiem zainstalowanych zależności należy zastosować się do komunikatów i wykonać polecenie
```
mix deps.get
```
a następnie ponownie wykonać polecenie uruchamiające.
