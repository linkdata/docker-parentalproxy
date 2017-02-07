all: build

build:
	@docker build --tag=linkdata/docker-parentalproxy .
