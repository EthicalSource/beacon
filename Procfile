#web: bundle exec puma -C config/puma.rb
web: bundle exec rails server -p $PORTresque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE=* bundle exec rake resque:work

