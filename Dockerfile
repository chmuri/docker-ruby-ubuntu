# Etap 1: Budowanie Ruby 1.9.3 na Ubuntu 22.04
FROM ubuntu:22.04 AS builder

# Instalujemy zależności potrzebne do kompilacji Ruby
RUN apt-get update && apt-get install -y build-essential openssl libssl-dev libreadline-dev zlib1g-dev libffi-dev libgdbm-dev libncurses5-dev wget

# Pobieramy kod źródłowy Ruby 1.9.3 i kompilujemy
RUN wget https://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p551.tar.gz \
    && tar -xzvf ruby-1.9.3-p551.tar.gz \
    && cd ruby-1.9.3-p551 \
    && ./configure --prefix=/usr/local/ruby-1.9.3 \
    && make \
    && make install

# Etap 2: Ostateczny obraz z Ruby 1.9.3 na Ubuntu 22.04
FROM ubuntu:22.04

# Kopiujemy skompilowany Ruby 1.9.3 z etapu poprzedniego
COPY --from=builder /usr/local/ruby-1.9.3 /usr/local/ruby-1.9.3

# Dodajemy Ruby 1.9.3 do zmiennej PATH, aby można było go uruchomić globalnie
ENV PATH="/usr/local/ruby-1.9.3/bin:${PATH}"

# Dodatkowo możemy ustawić Ruby 1.9.3 jako domyślną wersję, ale zalecamy korzystanie z nowszych wersji Rubiego.
RUN ln -s /usr/local/ruby-1.9.3/bin/ruby /usr/local/bin/ruby \
    && ln -s /usr/local/ruby-1.9.3/bin/gem /usr/local/bin/gem

# Ustawiamy katalog roboczy dla obrazu
WORKDIR /app

# Przykładowy skrypt, który może być skopiowany do kontenera i uruchomiony z użyciem Rubiego 1.9.3

# Uruchamiamy skrypt po uruchomieniu kontenera
CMD ["ruby"]

