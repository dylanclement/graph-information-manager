start:
	coffee src/app.coffee

start-servers:
	. /etc/init.d/redis_3630 start
	. ~/Programs/orientdb/bin/server.sh

stop-servers:
	. /etc/init.d/redis_3630 stop

test:
	@./node_modules/.bin/mocha --compilers coffee:coffee-script src/test

migrate:
	@./node_modules/.bin/migrate

.PHONY: test