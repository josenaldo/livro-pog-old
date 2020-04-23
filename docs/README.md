# Livro POG

## Comandos úteis

### Construção da imagem

```shell
docker build -t livro-pog .
```

### Execução do contêiner

```shell
docker run --rm -it -v "/d/repositorios/livro-pog:/srv/jekyll" -v "/d/repositorios/livro-pog/vendor/bundle:/usr/local/bundle" -p 4000:4000 -p 35729:35729 --name livro-pog livro-pog bash
```

### Pra executar o servidor de desenvolvimento

```shell
jekyll serve --watch --force-polling --livereload
```

### Descobrindo o IP do servidor de teste

```shell
docker-machine ip
```

O endereço para acesso é [http://IP_DO_DOCKER_MACHINE/livro-pog]([http://IP_DO_DOCKER_MACHINE/livro-pog])

### Conectando num container que está rodando

```shell
docker exec -it livro-pog bash
```

### Se precisar reconectar num servidor que já está rodando

```shell
killall jekyll
```

ou

```shell
pkill -u jekyll
```


git config --global user.email "josenaldo@gmail.com"
git config --global user.name "Josenaldo de Oliveira Matos Filho"