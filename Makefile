TARGETS := all requirements lint black
NOTEBOOKS := $(wildcard *.ipynb)

hello:
	@echo make [$(TARGETS)]

requirements:
	pip install --upgrade pip
	pip install --quiet --upgrade --requirement requirements.txt

lint:
	black --diff *.py
	black --diff --ipynb *.ipynb

black:
	black *.py
	black --ipynb *.ipynb

lab:
	jupyter lab

run:
	$(foreach notebook, $(NOTEBOOKS), jupyter nbconvert --execute --inplace $(notebook);

clean:
	jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace *.ipynb

all: requirements lint
