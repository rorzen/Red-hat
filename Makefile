#
# Generate documentation in HTML and PDF
#

HIDE ?= @

.PHONY: install pre-publish publish publish-html post-process-html publish-pdf serve publish-and-serve clean

DEST_DIR := dist
HTML_DEST_DIR := $(DEST_DIR)/html
BACKENDS_DIR := resources/repos/asciidoctor-backends
HTML_FILE := $(HTML_DEST_DIR)/index-ug.html
HTML_OPTS := -T ./$(BACKENDS_DIR)/slim/html5-frost -a stylesheet=resources/stylesheets/frost-doc.css -D $(HTML_DEST_DIR)
PDF_OPTS := -a book-build -a allow-uri-read -a pdf-stylesdir=./resources -a pdf-style=./themes/bp-2019-theme.yml -a pdf-fontsdir=resources/fonts -D $(DEST_DIR)
# RUBY_PATH := PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"

#
# Install & Setup targets
#

install:
	$(HIDE)gem install --user-install asciidoctor tilt haml thread_safe
	$(HIDE)gem install --user-install slim --version 2.1.0
	$(HIDE)gem install --user-install asciidoctor-pdf --pre

#
# Publish targets
#

pre-publish: clean
	$(HIDE)mkdir dist

publish: pre-publish publish-html publish-pdf

publish-html: build-html after-build-html

build-html:
	$(HIDE)$(RUBY_PATH) asciidoctor $(HTML_OPTS) index-ug.adoc

after-build-html:
	$(HIDE)mkdir -p $(HTML_DEST_DIR)/resources
	$(HIDE)cp -r resources/images $(HTML_DEST_DIR)/resources/images
	$(HIDE)cp -r resources/js $(HTML_DEST_DIR)/resources/js
	$(HIDE)cp -r images $(HTML_DEST_DIR)/images

publish-pdf:
	$(HIDE)asciidoctor-pdf $(PDF_OPTS) index-ug.adoc

#	$(HIDE)$(RUBY_PATH) asciidoctor-pdf $(PDF_OPTS) index.adoc

#
# Serve targets
#

serve:
	$(HIDE)cd $(HTML_DEST_DIR) && http-server

publish-and-serve: publish serve

#
# Clean targets
#

clean:
	$(HIDE)rm -rf dist
