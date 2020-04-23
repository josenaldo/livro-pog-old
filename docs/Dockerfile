FROM jekyll/jekyll:3.8.5

LABEL author Josenaldo Matos

VOLUME [ "/srv/jekyll", "/usr/local/bundle" ]

ENV JEKYLL_ENV production

EXPOSE 4000

RUN gem install reduce
RUN chmod 777 /srv/jekyll
RUN git config --global user.email "josenaldo@gmail.com"
RUN git config --global user.name "Josenaldo de Oliveira Matos Filho"
