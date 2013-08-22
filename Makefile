watch-test:
	./node_modules/.bin/mocha \
		--compilers coffee:coffee-script \
		--watch \
		--reporter nyan

.PHONY: watch-test
