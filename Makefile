ci: format freeze doc test

all: update ci

update:
	@python3 scripts/update.py
	@./Shakefile.hs

format:
	@find . -name "*.dhall" -exec dhall --ascii format --inplace {} \;

freeze:
	@dhall --ascii freeze --inplace typesUnion.dhall --all
	@dhall --ascii freeze --inplace schemas.dhall --all
	@dhall --ascii freeze --inplace package.dhall --all

doc:
	@python3 scripts/doc.py

test:
	@dhall-to-yaml --file ./examples/dhall-zuul-ci.dhall --output .zuul.yaml
