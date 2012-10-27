test:
	@./node_modules/.bin/mocha src

migrate:
	@./node_modules/.bin/migrate

.PHONY: test