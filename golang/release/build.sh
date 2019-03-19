#!/bin/sh

set -eux

PROJECT_ROOT="/go/src/github.com/${GITHUB_REPOSITORY}"
PROJECT_NAME=$(basename $GITHUB_REPOSITORY)
CI_COMMIT_TAG=""

mkdir -p $PROJECT_ROOT
rmdir $PROJECT_ROOT
ln -s $GITHUB_WORKSPACE $PROJECT_ROOT
cd $PROJECT_ROOT
go get -v ./...

CGO_ENABLED=0 GOOS=linux \
  go build \
  -a \
  -ldflags "-X main.CI_COMMIT_TAG=$CI_COMMIT_TAG" \
  -installsuffix cgo -o $PROJECT_NAME ./cmd/main.go

GOARCH=amd64 GOOS=windows \
  go build \
  -a \
  -ldflags "-X main.CI_COMMIT_TAG=$CI_COMMIT_TAG" \
  -installsuffix cgo -o $PROJECT_NAME.exe ./cmd/main.go
