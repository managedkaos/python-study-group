TARGETS := all requirements lint black

hello:
	@echo make [$(TARGETS)]

requirements:
	pip install --upgrade pip
	pip install --quiet --upgrade --requirement requirements.txt

lint:
	black --diff --ipynb *.ipynb

black:
	black --ipynb *.ipynb

lab:
	jupyter lab

all: requirements lint
