IMAGE ?= squidfunk/mkdocs-material@sha256:2c8eeebc51e812a9e023acd54f4716a5af335d90a91cafbac9b84afe409df056

all:
	docker run --rm -it --user $$(id -u):$$(id -g) -v $(PWD):/docs $(IMAGE) build

debug:
	docker run --rm -it -p 8000:8000 -v $(PWD):/docs $(IMAGE)

clean:
	$(if $(wildcard site), rm -r site)

netlify:
	apt-get install python3-pip || sudo apt-get install python3-pip
	python -m ensurepip --upgrade
	python -m pip install --upgrade pip
	# https://github.com/squidfunk/mkdocs-material/blob/77171e02a4aa4b346cd95f796f5721369d02ab8a/Dockerfile
	pip install --no-cache-dir mkdocs-material 'mkdocs-minify-plugin>=0.3' 'mkdocs-redirects>=1.0'
	mkdocs build
