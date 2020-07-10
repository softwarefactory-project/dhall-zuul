ci: format freeze doc test

all: update ci

update:
	@./Shakefile.hs

format:
	@find . -name "*.dhall" -exec dhall --ascii format --inplace {} \;

freeze:
	@python3 scripts/update.py

doc:
	@python3 scripts/doc.py

test:
	@dhall-to-yaml --file ./examples/dhall-zuul-ci.dhall --output .zuul.yaml
