coffee:
	./node_modules/.bin/coffee --watch --compile --output lib coffee

watch-test:
	./node_modules/.bin/mocha \
		--compilers coffee:coffee-script \
		--watch \
		--reporter nyan

.PHONY: test coffee
