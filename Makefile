TARGETS := all requirements lint black

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
	jupyter execute --inplace --execute *.ipynb

clean:
	jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace *.ipynb

all: requirements lint
