#!/bin/bash
set +e
set +x

export RAILS_ENV=test
cp config/database.yml.example config/database.yml
bundle
bundle exec rake tmp:create
bundle exec rake db:test:load
bundle exec rake db:migrate
bundle exec rake ci:setup:rspec spec
