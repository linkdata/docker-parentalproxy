all: build

build:
	@docker build --tag=${USER}/docker-squidguard .
