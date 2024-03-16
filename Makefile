TARGETS := all requirements lint black
NOTEBOOKS := $(wildcard *.ipynb)
TAG := $(shell git rev-parse --short HEAD)

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

deploy:
	aws cloudformation create-stack \
		--stack-name sagemaker-demo-$(TAG) \
		--capabilities CAPABILITY_IAM  \
		--template-body file://00-sagemaker-notebook-cloudformation.yml

	aws cloudformation wait stack-create-complete \
		--stack-name sagemaker-demo-$(TAG)

	aws cloudformation describe-stacks \
		--stack-name sagemaker-demo-$(TAG) \
		| jq -r '.Stacks[0].Outputs[] | "\(.OutputKey) = \(.OutputValue)"'

delete:
	aws cloudformation delete-stack \
		--stack-name sagemaker-demo-$(TAG)

	aws cloudformation wait stack-delete-complete \
		--stack-name sagemaker-demo-$(TAG)

clean:
	nb-clean clean *.ipynb

nuke: clean
	rm -f index.html
	rm -rvf ./data
	rm -rf __pycache__ .ipynb_checkpoints

all: requirements lint

.PHONY: $(TARGETS) hello run lab deploy delete clean nuke all
