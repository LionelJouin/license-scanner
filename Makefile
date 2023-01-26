.PHONY: default
default:
	echo "no default"

.PHONY: all
all: default

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-45s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

############################################################################
# Variables
############################################################################

PROJECT := 

OUTPUT_DIR ?= _output

#############################################################################
##@ Stats / Coverage
#############################################################################

.PHONY: scan
scan: output-dir ## Scan the projects
	@./scanner.sh

#############################################################################
# Tools
#############################################################################

.PHONY: output-dir
output-dir:
	@mkdir -p $(OUTPUT_DIR)