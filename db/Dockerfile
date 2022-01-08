FROM postgres:13.2
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DB iita
COPY init/createDB.sql /docker-entrypoint-initdb.d/
