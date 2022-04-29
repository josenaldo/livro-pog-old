# Livro POG

## Comandos úteis

### Construção da imagem

```shell
docker build -t livro-pog .
```

Após a construção da imagem, lembre-se de verificar se o compartilhamento de arquivos está ligado, para a pasa onde está o projeto.

### Execução do contêiner

```shell
docker run --rm -it -v "e:\repositorios\livro-pog:/srv/jekyll" -v "e:\repositorios\livro-pog\vendor\bundle:/usr/local/bundle" -p 4000:4000 -p 35729:35729 --name livro-pog livro-pog bash
```

ou

```shell
docker run --rm -it -v "d:\repositorios\livro-pog:/srv/jekyll" -v "d:\repositorios\livro-pog\vendor\bundle:/usr/local/bundle" -p 4000:4000 -p 35729:35729 --name livro-pog livro-pog bash
```

Se, após a execução desse comando, ocorrer algum problema com o docker em relação a diretórios já existente, atualize o docker e reinicie a máquina.

Talvez, reiniciar o docker-machine ou o próprio docker funcione. Teste essa hipótese.

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
pkill -u jekyll
```

### Configurando o Git

git config --global user.email "josenaldo@gmail.com"
git config --global user.name "Josenaldo de Oliveira Matos Filho"
