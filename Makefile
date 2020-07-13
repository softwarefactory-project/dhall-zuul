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

publish:
	@dhall-docs --input . --package-name dhall-zuul
	@find docs/ -type d -exec chmod 0755 {} +
	@find docs/ -type f -exec chmod 0644 {} +
	@rsync --exclude .zuul.yaml --exclude .gitreview --exclude _build --exclude .git  -avi $(pwd)/ pagesuser@www.softwarefactory-project.io:/var/www/pages/www.softwarefactory-project.io/dhall-zuul/
