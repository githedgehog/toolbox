set shell := ["bash", "-euo", "pipefail", "-c"]

import "hack/tools.just"

# Print list of available recipes
default:
  @just --list

export CGO_ENABLED := "0"

_gotools:
  go fmt ./...
  go vet {{go_flags}} ./...

# Called in CI
_lint: _license_headers _gotools

# Generate, lint, test and build everything
all: gen lint lint-gha test build && version

# Run linters against code (incl. license headers)
lint: _lint _golangci_lint
  {{golangci_lint}} run --show-stats ./...

# Run golangci-lint to attempt to fix issues
lint-fix: _lint _golangci_lint
  {{golangci_lint}} run --show-stats --fix ./...

go_base_flags := ""
go_flags := go_base_flags + " -ldflags=\"-w -s -X go.githedgehog.com/toolbox/pkg/version.Version=" + version + "\""
go_build := "go build " + go_flags
go_linux_build := "GOOS=linux GOARCH=amd64 " + go_build

# Generate docs, code/manifests, things to embed, etc
gen:
  # noop

oci_repo := "127.0.0.1:30000"
oci_prefix := "githedgehog/toolbox"
oci_fabricator_prefix := "githedgehog/fabricator"

# Build all artifacts
build: _license_headers gen _gotools && version
  {{go_linux_build}} -o ./bin/version ./cmd/version
  {{go_linux_build}} -o ./bin/demo ./cmd/demo
  docker build --platform=linux/amd64 -t {{oci_repo}}/{{oci_prefix}}:{{version}} -f Dockerfile .

# Push all toolbox image
push: _skopeo _oras build && version
  {{skopeo}} --insecure-policy copy {{skopeo_copy_flags}} {{skopeo_dest_insecure}} docker-daemon:{{oci_repo}}/{{oci_prefix}}:{{version}} docker://{{oci_repo}}/{{oci_prefix}}:{{version}}
  docker save -o toolbox.tar {{oci_repo}}/{{oci_prefix}}:{{version}}
  oras push {{oras_insecure}} {{oci_repo}}/{{oci_fabricator_prefix}}/toolbox:{{version}} toolbox.tar

# Run specified command with args with minimal Go flags (no version provided)
run cmd *args:
  @echo "Running: {{cmd}} {{args}} (run gen manually if needed)"
  @go run {{go_base_flags}} ./cmd/{{cmd}} {{args}}
