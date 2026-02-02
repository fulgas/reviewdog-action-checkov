# Checkov + Reviewdog GitHub Action

[![Marketplace](https://img.shields.io/badge/marketplace-Checkov%20%2B%20Reviewdog-blue)](https://github.com/marketplace/actions/run-checkov-with-reviewdog)
[![GitHub release](https://img.shields.io/github/v/release/fulgas/reviewdog-action-checkov?label=release)](https://github.com/fulgas/reviewdog-action-checkov/releases)
[![Checkov](https://img.shields.io/github/v/release/bridgecrewio/checkov?label=Checkov&color=6B46C1&logo=python&logoColor=white)](https://www.checkov.io/)
[![Reviewdog](https://img.shields.io/github/v/release/reviewdog/reviewdog?label=Reviewdog&color=F97316&logo=go&logoColor=white)](https://github.com/reviewdog/reviewdog)

## Description

<!-- AUTO-DOC-DESCRIPTION:START - Do not remove or modify this section -->

A GitHub Action that runs [Checkov](https://www.checkov.io/) for Infrastructure as Code (IaC) security scanning and reports results to pull requests using [reviewdog](https://github.com/reviewdog/reviewdog).

<!-- AUTO-DOC-DESCRIPTION:END -->

## Features

- 🔍 Scan Terraform, CloudFormation, Kubernetes, and other IaC files
- 🐶 Inline PR comments with reviewdog
- 🎯 Configurable severity levels and filters
- 🚀 Easy to integrate into existing workflows
- 🐳 Pre-built Docker image on GHCR for faster execution
- 🤖 Automated dependency updates via Renovate

## Usage

### Basic Example

```yaml
name: Checkov Review
on: [pull_request]

permissions:
  contents: read
  pull-requests: write
  checks: write

jobs:
  checkov:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Checkov with reviewdog
        uses: fulgas/reviewdog-action-checkov@v2.4.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Advanced Example

```yaml
name: Checkov Review
on: [pull_request]

permissions:
  contents: read
  pull-requests: write
  checks: write

jobs:
  checkov:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Checkov with reviewdog
        uses: fulgas/reviewdog-action-checkov@v2.4.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
          level: warning
          filter_mode: nofilter
          fail_level: error
          working_directory: terraform/
          skip_check: "CKV_AWS_1 CKV_AWS_2"
          framework: terraform,kubernetes
          flags: "--soft-fail"
```

### Using Docker Image from GHCR

You can also run the action directly using the Docker image:

```yaml
name: Checkov Review
on: [pull_request]

permissions:
  contents: read
  pull-requests: write
  checks: write

jobs:
  checkov:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/fulgas/reviewdog-action-checkov:2.4.0
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Checkov
        env:
          REVIEWDOG_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          INPUT_REPORTER: github-pr-check
          INPUT_LEVEL: error
          INPUT_FILTER_MODE: added
          INPUT_FAIL_LEVEL: error
          INPUT_WORKING_DIRECTORY: "."
          INPUT_TARGET_DIR: "."
          INPUT_SKIP_CHECK: ""
          INPUT_FRAMEWORK: ""
          INPUT_FLAGS: ""
        run: /entrypoint.sh
```

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->

|                                        INPUT                                        |  TYPE  | REQUIRED |           DEFAULT            |                                     DESCRIPTION                                      |
|-------------------------------------------------------------------------------------|--------|----------|------------------------------|--------------------------------------------------------------------------------------|
|           <a name="input_fail_level"></a>[fail_level](#input_fail_level)            | string |  false   |          `"error"`           | If set to none, always <br>use exit code 0. Otherwise <br>fail if findings >= level  |
|          <a name="input_filter_mode"></a>[filter_mode](#input_filter_mode)          | string |  false   |          `"added"`           |           Filtering mode for reviewdog [added,diff_context,file,nofilter]            |
|                   <a name="input_flags"></a>[flags](#input_flags)                   | string |  false   |                              |                       Additional flags to pass to <br>Checkov                        |
|             <a name="input_framework"></a>[framework](#input_framework)             | string |  false   |                              |     Comma-separated list of frameworks to <br>scan (e.g., terraform,kubernetes)      |
|        <a name="input_github_token"></a>[github_token](#input_github_token)         | string |   true   |   `"${{ github.token }}"`    |                                     GITHUB_TOKEN                                     |
|                   <a name="input_level"></a>[level](#input_level)                   | string |  false   |          `"error"`           |                   Report level for reviewdog [info,warning,error]                    |
|              <a name="input_reporter"></a>[reporter](#input_reporter)               | string |  false   |     `"github-pr-check"`      |    Reporter of reviewdog command [github-pr-check,github-pr-review,github-check]     |
|           <a name="input_skip_check"></a>[skip_check](#input_skip_check)            | string |  false   |                              |   Space-separated list of Checkov checks <br>to skip (e.g., CKV_AWS_1 CKV_AWS_2)     |
|           <a name="input_target_dir"></a>[target_dir](#input_target_dir)            | string |  false   |            `"."`             |                      Target directory for Checkov to <br>scan                        |
|             <a name="input_tool_name"></a>[tool_name](#input_tool_name)             | string |   true   | `"reviewdog-action-checkov"` |                     Tool name to use for <br>reviewdog reporter                      |
| <a name="input_working_directory"></a>[working_directory](#input_working_directory) | string |  false   |            `"."`             |                        Directory to run the action <br>from                          |

<!-- AUTO-DOC-INPUT:END -->

## Outputs

<!-- AUTO-DOC-OUTPUT:START - Do not remove or modify this section -->

|                                              OUTPUT                                               |  TYPE  |          DESCRIPTION          |
|---------------------------------------------------------------------------------------------------|--------|-------------------------------|
|    <a name="output_checkov-return-code"></a>[checkov-return-code](#output_checkov-return-code)    | string |  Checkov command return code  |
| <a name="output_reviewdog-return-code"></a>[reviewdog-return-code](#output_reviewdog-return-code) | string | reviewdog command return code |

<!-- AUTO-DOC-OUTPUT:END -->

## Configuration Guide

### Reporter Modes

The `reporter` input determines how findings are displayed in your pull request or workflow.

| Reporter | Description | Output Location | Permissions Required | Best For |
|----------|-------------|----------------|---------------------|----------|
| `github-pr-review` | Creates inline comments on PR | PR conversation & Files changed tab | `pull-requests: write`<br>`contents: read` | Code review, team collaboration |
| `github-pr-check` | Creates check run with annotations | PR checks tab & Files changed | `checks: write`<br>`contents: read` | CI/CD pipelines, status checks |
| `github-check` | Creates general check run | Actions tab | `checks: write`<br>`contents: read` | Branch monitoring, scheduled scans |

#### Visual Comparison

**github-pr-review** - Inline comments directly on your code:

![PR Review Example](docs/images/github-pr-review.png)

**github-pr-check** - Check annotations in the Files changed tab:

![Check Annotation](docs/images/github-pr-check-annotation.png)

Collapsible findings summary in the Checks tab:

![Check Summary](docs/images/github-pr-check-summary.png)

Expandable list of all findings:

![Check Findings](docs/images/github-pr-check-findings.png)

#### Reporter Examples

**github-pr-review** - Inline PR Comments:
```yaml
name: Checkov PR Review
on: [pull_request]

permissions:
  contents: read
  pull-requests: write  # Required!
  checks: write

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Checkov
        uses: fulgas/reviewdog-action-checkov@v2.4.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
```

**github-pr-check** - Check Annotations:
```yaml
name: Checkov PR Check
on: [pull_request]

permissions:
  contents: read
  checks: write  # Required!
  pull-requests: read  # Optional

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Checkov
        uses: fulgas/reviewdog-action-checkov@v2.4.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-check
```

**github-check** - General Checks:
```yaml
name: Checkov Scan
on:
  push:
    branches: [main]
  schedule:
    - cron: '0 0 * * 0'

permissions:
  contents: read
  checks: write  # Required!

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Checkov
        uses: fulgas/reviewdog-action-checkov@v2.4.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-check
```

### Filter Modes

The `filter_mode` input controls which findings are reported based on your PR changes.

| Mode           | Shows Findings For             | Use Case              | Example                                        |
|----------------|--------------------------------|-----------------------|------------------------------------------------|
| `added`        | Only new/modified lines in PR  | New code review       | You add line 10, only issues on line 10 shown  |
| `diff_context` | Lines in and around PR changes | Understanding context | You change line 10, issues on lines 8-12 shown |
| `file`         | All lines in changed files     | File-level review     | You change 1 line, all issues in file shown    |
| `nofilter`     | Entire repository              | Full security audit   | Shows all issues regardless of changes         |

⚠️ **Warning:** `nofilter` can report hundreds of findings in large repositories! Use `added` or `diff_context` for PR reviews.

### Severity Levels

Control what gets reported and when workflows fail:

| Input        | Values                             | Purpose                       | Example                                    |
|--------------|------------------------------------|-------------------------------|--------------------------------------------|
| `level`      | `info`, `warning`, `error`         | What findings to **show**     | `level: warning` shows warnings and errors |
| `fail_level` | `none`, `info`, `warning`, `error` | When to **fail** the workflow | `fail_level: error` only fails on errors   |

## Permissions Reference

### Permission Requirements by Reporter

Each reporter requires specific GitHub permissions to function properly:

| Reporter           | Required Permissions                                          | Optional              |
|--------------------|---------------------------------------------------------------|-----------------------|
| `github-pr-review` | `contents: read`<br>`pull-requests: write`<br>`checks: write` | -                     |
| `github-pr-check`  | `contents: read`<br>`checks: write`                           | `pull-requests: read` |
| `github-check`     | `contents: read`<br>`checks: write`                           | -                     |

## Examples Directory

Ready-to-use workflow examples are available in the [`docs/examples/`](docs/examples/) directory.

- **[basic-pr-review.yml](docs/examples/basic-pr-review.yml)** - Simple PR review with inline comments
- **[ci-security-gate.yml](docs/examples/ci-security-gate.yml)** - Strict CI/CD gate that blocks on errors
- **[terraform-scan.yml](docs/examples/terraform-scan.yml)** - Terraform-specific scanning
- **[multi-framework.yml](docs/examples/multi-framework.yml)** - Scan multiple IaC frameworks
- **[scheduled-audit.yml](docs/examples/scheduled-audit.yml)** - Weekly security audit

Copy any of these to your `.github/workflows/` directory and customize as needed.

See the [Configuration Guide](#configuration-guide) above for detailed explanations of all options.

## Troubleshooting

### Permission Errors

**Error: "Resource not accessible by integration"**

This means your workflow is missing required permissions.

```yaml
# Solution: Add the missing permission
permissions:
  contents: read
  pull-requests: write  # Required for github-pr-review
  checks: write         # Required for github-pr-check and github-check
```

**Error: "Not Found" or "403 Forbidden"**

The `GITHUB_TOKEN` doesn't have access to the repository.

```yaml
# Solution: Ensure contents: read is set
permissions:
  contents: read  # Always required
```

### No Findings or Empty Output

**Problem: Action runs but reports no findings**

Possible causes:

1. **Wrong target directory**
   ```yaml
   # Check your target_dir points to IaC files
   with:
     target_dir: "terraform/"  # Update to match your structure
   ```

2. **Wrong framework specified**
   ```yaml
   # Ensure framework matches your files
   with:
     framework: terraform  # Change to match your IaC type
   ```

3. **All checks skipped**
   ```yaml
   # Review your skip_check list
   with:
     skip_check: ""  # Remove if too many checks are skipped
   ```

### Too Many Findings

**Problem: Hundreds of findings reported**

**Solution: Use appropriate filter mode**

```yaml
# For PRs - only show new issues
with:
  filter_mode: added  # Only new/modified lines

# For audits - expect many findings
with:
  filter_mode: nofilter  # Full repository scan
  fail_level: none        # Don't block on findings
```

⚠️ **Warning:** `nofilter` can report hundreds of findings in large repositories. Use `added` or `diff_context` for PR reviews.

### Check Not Appearing

**Problem: Workflow runs but check doesn't appear on PR**

1. **Wrong reporter for your use case**
```yaml
# For PR checks:
reporter: github-pr-check  # Shows in Checks tab

# For PR comments:
reporter: github-pr-review  # Shows inline comments
```

2. **Missing permissions**
   ```yaml
   # Ensure you have the right permissions
   permissions:
     checks: write  # Required for check reporters
   ```

### Workflow Fails Unexpectedly

**Problem: Workflow fails even with `fail_level: none`**

**Cause:** Checkov itself failed (not findings, but an error running Checkov)

**Solutions:**

1. **Check Checkov logs** in the workflow output
2. **Verify file syntax** - malformed IaC files can crash Checkov
3. **Update target directory** - ensure it exists and contains files

### Common Configuration Mistakes

**Mistake 1: Using wrong reporter**
```yaml
# ❌ Wrong - using PR reporter on scheduled scan
on:
  schedule:
    - cron: '0 0 * * 0'
jobs:
  scan:
    steps:
      - uses: fulgas/reviewdog-action-checkov@v2.4.0
        with:
          reporter: github-pr-review  # Won't work on schedule

# ✅ Correct
          reporter: github-check  # Works for scheduled scans
```

**Mistake 2: Blocking PRs unintentionally**
```yaml
# ❌ Wrong - fail_level defaults to 'error'
- uses: fulgas/reviewdog-action-checkov@v2.4.0
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    # No fail_level set - will block on errors!

# ✅ Correct - explicit fail_level
    fail_level: none  # Advisory mode, never blocks
```

**Mistake 3: Scanning wrong directory**
```yaml
# ❌ Wrong - defaults to current directory
- uses: fulgas/reviewdog-action-checkov@v2.4.0
  with:
    # No target_dir - scans entire repo

# ✅ Correct - specific directory
    target_dir: "infrastructure/terraform"
```

### Token Issues

**Problem: REVIEWDOG_GITHUB_API_TOKEN errors**

**Solution:** Use the built-in `GITHUB_TOKEN`

```yaml
- uses: fulgas/reviewdog-action-checkov@v2.4.0
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}  # Built-in token
```

Don't create a custom token unless you have specific needs.

### Getting Help

If you're still having issues:

1. **Check the [Configuration Guide](#configuration-guide)** for detailed examples
2. **Review [workflow examples](docs/examples/)** for working configurations
3. **Open an issue** with:
    - Your workflow YAML
    - Error messages from logs
    - Expected vs actual behavior

## Development

### Multi-Platform Support

This action supports both **AMD64** and **ARM64** architectures:
- ✅ Works on Apple Silicon (M1/M2/M3 Macs)
- ✅ Works on AWS Graviton runners
- ✅ Works on standard x86_64 runners

The CI workflow tests both architectures to ensure compatibility.

### Building Locally

```bash
# Build for your native architecture
docker build -t reviewdog-action-checkov .

# Or build for a specific platform
docker build --platform linux/amd64 -t reviewdog-action-checkov:amd64 .
docker build --platform linux/arm64 -t reviewdog-action-checkov:arm64 .
```

### Running Tests

The CI workflow automatically builds the Dockerfile and tests it against all supported frameworks (Terraform, CloudFormation, Kubernetes) on multiple platforms and Ubuntu versions.

To test locally:

```bash
# Build the image
docker build -t reviewdog-action-checkov:test .

# Run against test files
docker run --rm \
  -v $(pwd):/github/workspace \
  -e GITHUB_WORKSPACE=/github/workspace \
  -e REVIEWDOG_GITHUB_API_TOKEN=your_token \
  -e INPUT_REPORTER=local \
  -e INPUT_FRAMEWORK=terraform \
  -e INPUT_TARGET_DIR=tests/terraform \
  reviewdog-action-checkov:test
```

### How It Works

1. **Action Usage**: The action uses a pre-built Docker image from GHCR (`ghcr.io/fulgas/reviewdog-action-checkov:2.4.0`)
2. **CI Testing**: The CI workflow builds the Dockerfile from source and runs tests against it to validate changes
3. **Publishing**: When a release is created, the Docker image is built and published to GHCR with the release tag

This approach provides the best of both worlds:
- Users get fast action execution with pre-built images
- Developers can test Dockerfile changes before they're published

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines including:
- How to report issues
- Pull request process
- Code style guidelines
- Semantic commit message format
- Testing requirements

### Quick Contribution Guide

1. Fork the repository and create a branch from `main`
2. Follow the [semantic commit convention](CONTRIBUTING.md#commit-messages)
3. Test your changes locally
4. Update documentation as needed
5. Submit a pull request

This project uses [Conventional Commits](https://www.conventionalcommits.org/) for automated versioning:
- `feat:` → Minor version bump (new features)
- `fix:` → Patch version bump (bug fixes)
- `feat!:` → Major version bump (breaking changes)

See [CONTRIBUTING.md](CONTRIBUTING.md#format) for complete commit message guidelines and examples.

## License

[MIT](LICENSE)

## Credits

- [Checkov](https://github.com/bridgecrewio/checkov) - IaC security scanner by Bridgecrew/Prisma Cloud
- [reviewdog](https://github.com/reviewdog/reviewdog) - Automated code review tool

## Support

- 🐛 [Issue Tracker](https://github.com/fulgas/reviewdog-action-checkov/issues)
- ☕ [Buy me a coffee](https://buymeacoffee.com/fulgas)