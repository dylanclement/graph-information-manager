start:
	coffee src/app.coffee

start-servers:
	. /etc/init.d/redis_3630 start
	. ~/Programs/orientdb/bin/server.sh

stop-servers:
	. /etc/init.d/redis_3630 stop

test:
	@./node_modules/.bin/mocha src

migrate:
	@./node_modules/.bin/migrate

.PHONY: test