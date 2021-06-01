YARN                  ?= yarn
YARN_FLAGS            ?=
NAME             			?= corteza-webapp-one

BUILD_FLAGS           ?= --production
BUILD_DEST_DIR        ?= dist
BUILD_VERSION         ?= $(shell git symbolic-ref -q HEAD | sed 's/refs\/heads\///g')
BUILD_NAME            ?= $(NAME)-$(BUILD_VERSION)

RELEASE_DIR           ?= release
RELEASE_NAME          ?= $(BUILD_NAME).noarch.tar.gz
RELEASE_EXTRA_FILES   ?= README.md LICENSE CONTRIBUTING.md DCO


.PHONY: help
help: ## show make targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-\\.%]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: dep
dep: ## install dependencies
	@echo Installing dependencies
	$(YARN) $(YARN_FLAGS) install

.PHONY: test
test: dep ## run tests
	@echo Running linter
	$(YARN) $(YARN_FLAGS) lint
	@echo Running unit tests
	$(YARN) $(YARN_FLAGS) test:unit

.PHONY: build
build: dep ## build application
	@echo Building application
	@rm -rf $(BUILD_DEST_DIR)
	$(YARN) $(YARN_FLAGS) build $(BUILD_FLAGS)

.PHONY: release
release: build ## release application
	@echo Packing release
	@cp $(RELEASE_EXTRA_FILES) $(BUILD_DEST_DIR)
	@mkdir -p $(RELEASE_DIR)
	@tar -C $(BUILD_DEST_DIR) -czf $(RELEASE_DIR)/$(RELEASE_NAME) $(dir $(BUILD_DEST_DIR))

.PHONY: clean
clean: ## clean build dir
	@echo Cleaning
	@rm -rf $(BUILD_DEST_DIR) $(RELEASE_DIR)
