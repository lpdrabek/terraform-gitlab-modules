.PHONY: help lint lint-terraform lint-tflint lint-yaml fmt

help: ## Display this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

lint: ## Run all linters (terraform fmt, tflint, yamllint)
	@./lint.sh all

lint-terraform: ## Run terraform fmt check only
	@./lint.sh terraform

lint-tflint: ## Run tflint only
	@./lint.sh tflint

lint-yaml: ## Run yamllint only
	@./lint.sh yaml

fmt: ## Format all Terraform files
	@echo "Formatting Terraform files..."
	@docker run --rm \
		-v "$$(pwd):/workspace" \
		-w /workspace \
		hashicorp/terraform:1.10.3 \
		fmt -recursive
	@echo "Formatting complete ✓"
