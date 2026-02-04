#!/usr/bin/env bash
# Usage: ./lint.sh [terraform|tflint|yaml|all]

set -e

# Configuration
TERRAFORM_VERSION="1.10.3"
TFLINT_VERSION="v0.54.0"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
}

# Function to run terraform fmt
run_terraform_fmt() {
    print_status "Running Terraform format check..."
    if docker run --rm \
        -v "${REPO_ROOT}:/workspace" \
        -w /workspace \
        hashicorp/terraform:${TERRAFORM_VERSION} \
        fmt -check -recursive -diff; then
        print_status "Terraform format check passed ✓"
        return 0
    else
        print_error "Terraform format check failed ✗"
        print_warning "Run 'terraform fmt -recursive' to fix formatting issues"
        return 1
    fi
}

# Function to run tflint
run_tflint() {
    print_status "Running TFLint..."

    # Initialize tflint
    docker run --rm \
        -v "${REPO_ROOT}:/data" \
        -w /data \
        ghcr.io/terraform-linters/tflint:${TFLINT_VERSION} \
        --init

    # Run tflint
    if docker run --rm \
        -v "${REPO_ROOT}:/data" \
        -w /data \
        ghcr.io/terraform-linters/tflint:${TFLINT_VERSION} \
        --format compact --recursive; then
        print_status "TFLint check passed ✓"
        return 0
    else
        print_error "TFLint check failed ✗"
        return 1
    fi
}

# Function to run yamllint
run_yamllint() {
    print_status "Running YAML linting..."
    if docker run --rm \
        -v "${REPO_ROOT}:/data" \
        cytopia/yamllint:latest \
        .; then
        print_status "YAML lint check passed ✓"
        return 0
    else
        print_error "YAML lint check failed ✗"
        return 1
    fi
}

# Main script
main() {
    local target="${1:-all}"
    local exit_code=0

    cd "${REPO_ROOT}"

    case "${target}" in
        terraform)
            run_terraform_fmt || exit_code=$?
            ;;
        tflint)
            run_tflint || exit_code=$?
            ;;
        yaml)
            run_yamllint || exit_code=$?
            ;;
        all)
            print_status "Running all linters..."
            echo ""

            run_terraform_fmt || exit_code=$?
            echo ""

            run_tflint || exit_code=$?
            echo ""

            run_yamllint || exit_code=$?
            echo ""

            if [ ${exit_code} -eq 0 ]; then
                print_status "All linting checks passed! ✓"
            else
                print_error "Some linting checks failed ✗"
            fi
            ;;
        *)
            print_error "Unknown target: ${target}"
            echo "Usage: $0 [terraform|tflint|yaml|all]"
            exit 1
            ;;
    esac

    exit ${exit_code}
}

main "$@"
