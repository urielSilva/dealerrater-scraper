FROM ruby:latest
WORKDIR /usr/src/app/
ADD . /usr/src/app/
RUN bundle install
ENTRYPOINT ["ruby", "/usr/src/app/main.rb"]