#!/bin/bash

set -Eeuo pipefail

# --- START: FIX FOR LOCAL TESTING ---
# Set default values for GitHub environment variables if they are not set.
# This makes the script runnable locally for testing.
export GITHUB_WORKSPACE="${GITHUB_WORKSPACE:-/github/workspace}"
export GITHUB_OUTPUT="${GITHUB_OUTPUT:-/tmp/github_output}"

# Set defaults for action inputs, matching the action.yml defaults
export INPUT_WORKING_DIRECTORY="${INPUT_WORKING_DIRECTORY:-.}"
export INPUT_TARGET_DIR="${INPUT_TARGET_DIR:-.}"
export INPUT_REPORTER="${INPUT_REPORTER:-github-pr-check}"
export INPUT_LEVEL="${INPUT_LEVEL:-error}"
export INPUT_FILTER_MODE="${INPUT_FILTER_MODE:-added}"
export INPUT_FAIL_LEVEL="${INPUT_FAIL_LEVEL:-error}"
export INPUT_CHECKOV_VERSION="${INPUT_CHECKOV_VERSION:-latest}"
export INPUT_SKIP_CHECK="${INPUT_SKIP_CHECK:-}"
export INPUT_FRAMEWORK="${INPUT_FRAMEWORK:-}"
export INPUT_FLAGS="${INPUT_FLAGS:-}"

if [ ! -f "${GITHUB_OUTPUT}" ]; then
  mkdir -p "$(dirname "${GITHUB_OUTPUT}")"
  touch "${GITHUB_OUTPUT}"
fi

cd "${GITHUB_WORKSPACE}/${INPUT_WORKING_DIRECTORY}" || exit 1

echo '::group::✅ Verifying tools'
  reviewdog -version
  checkov --version
echo '::endgroup::'

echo '::group::🔍 Running Checkov with reviewdog 🐶 ...'
  export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

  CHECKOV_ARGS=""

  if [[ -n "${INPUT_SKIP_CHECK:-}" ]]; then
    for check in ${INPUT_SKIP_CHECK}; do
      CHECKOV_ARGS="${CHECKOV_ARGS} --skip-check ${check}"
    done
  fi

  if [[ -n "${INPUT_FRAMEWORK:-}" ]]; then
    CHECKOV_ARGS="${CHECKOV_ARGS} --framework ${INPUT_FRAMEWORK}"
  fi

  # Add custom flags
  if [[ -n "${INPUT_FLAGS:-}" ]]; then
    CHECKOV_ARGS="${CHECKOV_ARGS} ${INPUT_FLAGS}"
  fi

  TARGET_DIR="${INPUT_TARGET_DIR:-.}"

  echo "checkov --directory ${TARGET_DIR} --output sarif ${CHECKOV_ARGS}"

  set +Eeuo pipefail

  checkov --directory "${TARGET_DIR}" --output sarif "${CHECKOV_ARGS}" 2>&1 \
    | reviewdog -f=sarif \
        -name="checkov" \
        -reporter="${INPUT_REPORTER}" \
        -level="${INPUT_LEVEL}" \
        -filter-mode="${INPUT_FILTER_MODE}" \
        -fail-level="${INPUT_FAIL_LEVEL}"

  checkov_return="${PIPESTATUS[0]}" reviewdog_return="${PIPESTATUS[1]}" exit_code=$?
  echo "checkov-return-code=${checkov_return}" >> "${GITHUB_OUTPUT}"
  echo "reviewdog-return-code=${reviewdog_return}" >> "${GITHUB_OUTPUT}"
echo '::endgroup::'

exit "${exit_code}"