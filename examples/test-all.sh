#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLES_DIR="$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default behavior
SKIP_DESTROY=${SKIP_DESTROY:-false}
SKIP_APPLY=${SKIP_APPLY:-false}
AUTO_APPROVE=${AUTO_APPROVE:-false}

usage() {
    echo "Usage: $0 [OPTIONS] [DIRECTORY...]"
    echo ""
    echo "Run tofu validate, fmt, init, apply, and destroy on example directories."
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo "  -y, --yes         Auto-approve apply and destroy (no prompts)"
    echo "  --skip-apply      Skip apply and destroy steps (validate/fmt/init only)"
    echo "  --skip-destroy    Skip destroy step (leave resources running)"
    echo ""
    echo "Arguments:"
    echo "  DIRECTORY...      Specific directories to test (default: all)"
    echo ""
    echo "Environment variables:"
    echo "  SKIP_DESTROY=true   Skip destroy step"
    echo "  SKIP_APPLY=true     Skip apply and destroy steps"
    echo "  AUTO_APPROVE=true   Auto-approve apply and destroy"
    echo ""
    echo "Examples:"
    echo "  $0                     # Test all directories interactively"
    echo "  $0 -y                  # Test all directories with auto-approve"
    echo "  $0 --skip-apply        # Only validate, fmt, and init"
    echo "  $0 project labels      # Test only project and labels directories"
    exit 0
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Parse arguments
DIRS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -y|--yes)
            AUTO_APPROVE=true
            shift
            ;;
        --skip-apply)
            SKIP_APPLY=true
            shift
            ;;
        --skip-destroy)
            SKIP_DESTROY=true
            shift
            ;;
        *)
            DIRS+=("$1")
            shift
            ;;
    esac
done

# If no directories specified, find all
if [ ${#DIRS[@]} -eq 0 ]; then
    for dir in "$EXAMPLES_DIR"/*/; do
        if [ -d "$dir" ] && [ -f "$dir/main.tf" ]; then
            DIRS+=("$(basename "$dir")")
        fi
    done
fi

# Build approve flag
APPROVE_FLAG=""
if [ "$AUTO_APPROVE" = true ]; then
    APPROVE_FLAG="-auto-approve"
fi

# Track results
declare -A RESULTS
FAILED=0

run_tofu() {
    local dir="$1"
    local dir_path="$EXAMPLES_DIR/$dir"

    log_header "Testing: $dir"

    if [ ! -d "$dir_path" ]; then
        log_error "Directory not found: $dir_path"
        RESULTS["$dir"]="SKIP (not found)"
        return 1
    fi

    if [ ! -f "$dir_path/main.tf" ]; then
        log_warn "No main.tf found in $dir, skipping"
        RESULTS["$dir"]="SKIP (no main.tf)"
        return 0
    fi

    cd "$dir_path"

    # Format check
    log_info "Running tofu fmt -check..."
    if ! tofu fmt -check -recursive .; then
        log_warn "Formatting issues detected, fixing..."
        tofu fmt -recursive .
    fi
    log_success "Format OK"

    # Init
    log_info "Running tofu init..."
    if ! tofu init -upgrade; then
        log_error "Init failed for $dir"
        RESULTS["$dir"]="FAILED (init)"
        FAILED=$((FAILED + 1))
        return 1
    fi
    log_success "Init OK"

    # Validate
    log_info "Running tofu validate..."
    if ! tofu validate; then
        log_error "Validation failed for $dir"
        RESULTS["$dir"]="FAILED (validate)"
        FAILED=$((FAILED + 1))
        return 1
    fi
    log_success "Validate OK"

    if [ "$SKIP_APPLY" = true ]; then
        log_info "Skipping apply/destroy (--skip-apply)"
        RESULTS["$dir"]="OK (validate only)"
        return 0
    fi

    # Apply
    log_info "Running tofu apply..."
    if ! tofu apply $APPROVE_FLAG; then
        log_error "Apply failed for $dir"
        RESULTS["$dir"]="FAILED (apply)"
        FAILED=$((FAILED + 1))
        return 1
    fi
    log_success "Apply OK"

    if [ "$SKIP_DESTROY" = true ]; then
        log_info "Skipping destroy (--skip-destroy)"
        RESULTS["$dir"]="OK (not destroyed)"
        return 0
    fi

    # Destroy
    log_info "Running tofu destroy..."
    if ! tofu destroy $APPROVE_FLAG; then
        log_error "Destroy failed for $dir"
        RESULTS["$dir"]="FAILED (destroy)"
        FAILED=$((FAILED + 1))
        return 1
    fi
    log_success "Destroy OK"

    RESULTS["$dir"]="OK"
    return 0
}

# Main execution
echo ""
echo -e "${BLUE}Tofu Examples Test Runner${NC}"
echo -e "Directories to test: ${DIRS[*]}"
echo -e "Auto-approve: $AUTO_APPROVE"
echo -e "Skip apply: $SKIP_APPLY"
echo -e "Skip destroy: $SKIP_DESTROY"
echo ""

for dir in "${DIRS[@]}"; do
    run_tofu "$dir" || true
done

# Summary
log_header "Summary"
for dir in "${!RESULTS[@]}"; do
    status="${RESULTS[$dir]}"
    if [[ "$status" == OK* ]]; then
        echo -e "  ${GREEN}✓${NC} $dir: $status"
    elif [[ "$status" == SKIP* ]]; then
        echo -e "  ${YELLOW}○${NC} $dir: $status"
    else
        echo -e "  ${RED}✗${NC} $dir: $status"
    fi
done

echo ""
if [ $FAILED -gt 0 ]; then
    log_error "$FAILED directory(ies) failed"
    exit 1
else
    log_success "All directories passed!"
    exit 0
fi
