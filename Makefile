TARGETS := all requirements lint black
NOTEBOOKS := $(wildcard *.ipynb)

hello:
	@echo make [$(TARGETS)]

requirements:
	pip install --upgrade pip
	pip install --quiet --upgrade --requirement requirements.txt

lint:
	cfn-lint *.yml
	black --diff *.py
	black --diff --ipynb *.ipynb

black:
	black *.py
	black --ipynb *.ipynb

rain:
	rain fmt --write *.yml

lab:
	jupyter lab

run:
	$(foreach notebook, $(NOTEBOOKS), jupyter nbconvert --execute --inplace $(notebook); )

clean:
	jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace *.ipynb

nuke: clean
	rm -f index.html
	rm -rvf ./data
	rm -rf __pycache__ .ipynb_checkpoints

all: requirements lint
