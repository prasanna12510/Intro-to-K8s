.PHONY: all build

DOCKER  = docker
REPO    = prasanna1994
NAME    = html-proofer
VERSION = latest

all: build

build:
	$(DOCKER) build -t $(NAME) --rm .

tag: build
	$(DOCKER) tag $(NAME) $(REPO)/$(NAME):$(VERSION)

push: tag
	$(DOCKER) push $(REPO)/$(NAME):$(VERSION)
