#!/bin/bash
set -Eeuo pipefail

###############################################################################
# Move into working directory
###############################################################################
cd "${GITHUB_WORKSPACE}/${INPUT_WORKING_DIRECTORY}" || exit 1

###############################################################################
# Tools check
###############################################################################
echo '::group::✅ Verifying tools'
  reviewdog -version
  checkov --version
echo '::endgroup::'

###############################################################################
# Build dynamic Checkov args
###############################################################################
CHECKOV_ARGS=()

if [[ -n "${INPUT_SKIP_CHECK:-}" ]]; then
  for check in ${INPUT_SKIP_CHECK}; do
     CHECKOV_ARGS+=("--skip-check" "${check}")
  done
fi

if [[ -n "${INPUT_FRAMEWORK:-}" ]]; then
  CHECKOV_ARGS+=("--framework" "${INPUT_FRAMEWORK}")
fi

# Add custom flags
if [[ -n "${INPUT_FLAGS:-}" ]]; then
  for f in ${INPUT_FLAGS}; do
    CHECKOV_ARGS+=("${f}")
  done
fi

###############################################################################
# Run Checkov
###############################################################################
echo '::group::🔍 Running Checkov (quiet mode)…'

TARGET_DIR="${INPUT_TARGET_DIR:-.}"
RESULT_SARIF=$(mktemp -d)
SARIF_FILE="$RESULT_SARIF/results_sarif.sarif"
echo "Target Directory: ${TARGET_DIR}"
echo "Checkov args: ${CHECKOV_ARGS[*]}"

set +Eeuo pipefail

checkov --compact --quiet --directory "${TARGET_DIR}" --output sarif --output-file-path "${RESULT_SARIF}" "${CHECKOV_ARGS[@]}" 2>/dev/null

checkov_return=$?

set -Eeuo pipefail

###############################################################################
# Validate SARIF file exists & is not empty
###############################################################################
if [[ ! -s "${SARIF_FILE}" ]]; then
  echo "❌ Checkov did not generate SARIF output (${SARIF_FILE} missing or empty)"
  echo "::endgroup::"
  exit "${checkov_return}"
fi
echo '::endgroup::'

###############################################################################
# Run Reviewdog
###############################################################################
echo '::group::🐶 Running reviewdog'

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
set +Eeuo pipefail
# shellcheck disable=SC2002
cat "${SARIF_FILE}" | reviewdog \
  -f=sarif \
  -name="checkov" \
  -reporter="${INPUT_REPORTER}" \
  -level="${INPUT_LEVEL}" \
  -filter-mode="${INPUT_FILTER_MODE}" \
  -fail-level="${INPUT_FAIL_LEVEL}"

reviewdog_return=$?
set -Eeuo pipefail

echo '::endgroup::'
###############################################################################
# Pipeline result handling
###############################################################################
echo "::group::📦 Pipeline exit summary"
echo "Checkov exit code: ${checkov_return}"
echo "Reviewdog exit code: ${reviewdog_return}"
echo "::endgroup::"

echo "checkov-return-code=${checkov_return}" >> "${GITHUB_OUTPUT}"
echo "reviewdog-return-code=${reviewdog_return}" >> "${GITHUB_OUTPUT}"

exit "${reviewdog_return}"