IMAGE ?= squidfunk/mkdocs-material@sha256:2c8eeebc51e812a9e023acd54f4716a5af335d90a91cafbac9b84afe409df056

all:
	docker run --rm -it --user $$(id -u):$$(id -g) -v $(PWD):/docs $(IMAGE) build

debug:
	docker run --rm -it -p 8000:8000 -v $(PWD):/docs $(IMAGE)

clean:
	$(if $(wildcard site), rm -r site)
