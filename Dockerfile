FROM ruby:3.1
RUN apt-get update -qq && \
    apt-get install -y build-essential \
    nodejs \
    vim \
    default-mysql-client \
    cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /myapp
ENV APP_ROOT /myapp
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

# bundlerがエラーの原因になったら2.1.4でとりあえず指定
RUN gem update --system && gem install bundler 
RUN bundle install

COPY . $APP_ROOT

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
