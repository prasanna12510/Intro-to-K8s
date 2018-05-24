.PHONY: all build

DOCKER  = docker
REPO    = prasanna1994
NAME    = kubectl
VERSION = 1.10.0

all: build

build:
	$(DOCKER) build -t $(NAME) --rm .

tag: build
	$(DOCKER) tag $(NAME) $(REPO)/$(NAME):$(VERSION)

push: tag
	$(DOCKER) push $(REPO)/$(NAME):$(VERSION)

latest: push
	$(DOCKER) tag $(NAME) $(REPO)/$(NAME):latest
	$(DOCKER) push $(REPO)/$(NAME):latest
