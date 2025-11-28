# Checkov + Reviewdog GitHub Action

[![Marketplace](https://img.shields.io/badge/marketplace-Checkov%20%2B%20Reviewdog-blue)](https://github.com/marketplace/actions/run-checkov-with-reviewdog)
[![GitHub release](https://img.shields.io/github/v/release/fulgas/reviewdog-action-checkov?label=release)](https://github.com/fulgas/reviewdog-action-checkov/releases)
[![Checkov](https://img.shields.io/github/v/release/bridgecrewio/checkov?label=Checkov&color=6B46C1&logo=python&logoColor=white)](https://www.checkov.io/)
[![Reviewdog](https://img.shields.io/github/v/release/reviewdog/reviewdog?label=Reviewdog&color=F97316&logo=go&logoColor=white)](https://github.com/reviewdog/reviewdog)

A GitHub Action that runs [Checkov](https://www.checkov.io/) for Infrastructure as Code (IaC) security scanning and reports results to pull requests using [reviewdog](https://github.com/reviewdog/reviewdog).

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

jobs:
  checkov:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Checkov with reviewdog
        uses: fulgas/reviewdog-action-checkov@v1.2.0
        with:
          github_token: ${{ secrets.github_token }}
```

### Advanced Example

```yaml
name: Checkov Review
on: [pull_request]

jobs:
  checkov:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Checkov with reviewdog
        uses: fulgas/reviewdog-action-checkov@v1.2.0
        with:
          github_token: ${{ secrets.github_token }}
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

jobs:
  checkov:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/fulgas/reviewdog-action-checkov:1.2.0
    steps:
      - uses: actions/checkout@v4

      - name: Run Checkov
        env:
          REVIEWDOG_GITHUB_API_TOKEN: ${{ secrets.github_token }}
          INPUT_GITHUB_TOKEN: ${{ secrets.github_token }}
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

| Name                | Description                                                                | Default           | Required |
|---------------------|----------------------------------------------------------------------------|-------------------|----------|
| `github_token`      | GitHub token for API access                                                | -                 | ✅        |
| `level`             | Report level for reviewdog (`info`, `warning`, `error`)                    | `error`           | ❌        |
| `reporter`          | Reviewdog reporter (`github-pr-check`, `github-pr-review`, `github-check`) | `github-pr-check` | ❌        |
| `filter_mode`       | Filtering mode (`added`, `diff_context`, `file`, `nofilter`)               | `added`           | ❌        |
| `fail_level`        | Exit code level (`none`, `info`, `warning`, `error`)                       | `error`           | ❌        |
| `working_directory` | Directory to run action from                                               | `.`               | ❌        |
| `target_dir`        | Directory for Checkov to scan                                              | `.`               | ❌        |
| `skip_check`        | Space-separated checks to skip (e.g., `CKV_AWS_1 CKV_AWS_2`)               | `""`              | ❌        |
| `framework`         | Comma-separated frameworks to scan                                         | `""`              | ❌        |
| `flags`             | Additional Checkov flags                                                   | `""`              | ❌        |

## Outputs

| Name                    | Description                 |
|-------------------------|-----------------------------|
| `checkov-return-code`   | Checkov command exit code   |
| `reviewdog-return-code` | Reviewdog command exit code |


## Filter Modes

- **`added`** (default): Only show findings for lines added in the PR
- **`diff_context`**: Show findings for lines in the diff context
- **`file`**: Show findings for entire changed files
- **`nofilter`**: Show all findings in the repository

## Examples

### Scan only Terraform files

```yaml
- uses: fulgas/reviewdog-action-checkov@v1.2.0
  with:
    github_token: ${{ secrets.github_token }}
    framework: terraform
```

### Skip specific checks

```yaml
- uses: fulgas/reviewdog-action-checkov@v1.2.0
  with:
    github_token: ${{ secrets.github_token }}
    skip_check: "CKV_AWS_1 CKV_AWS_18 CKV_AWS_19"
```

### Scan specific directory

```yaml
- uses: fulgas/reviewdog-action-checkov@v1.2.0
  with:
    github_token: ${{ secrets.github_token }}
    working_directory: infrastructure/
    target_dir: terraform/
```

### Fail on warnings

```yaml
- uses: fulgas/reviewdog-action-checkov@v1.2.0
  with:
    github_token: ${{ secrets.github_token }}
    fail_level: warning
```

## Development

### Building Locally

```bash
docker build -t reviewdog-action-checkov .
```

### Testing

The CI workflow automatically builds the Dockerfile and tests it against all supported frameworks (Terraform, CloudFormation, Kubernetes). This ensures that changes to the Dockerfile are properly tested before being published to GHCR.

To test locally:

```bash
# Build the image
docker build -t reviewdog-action-checkov:test .

# Run tests
docker run --rm \
  -v $(pwd):/github/workspace \
  -e GITHUB_WORKSPACE=/github/workspace \
  -e INPUT_GITHUB_TOKEN=your_token \
  -e INPUT_REPORTER=local \
  -e INPUT_FRAMEWORK=terraform \
  -e INPUT_TARGET_DIR=tests/terraform \
  reviewdog-action-checkov:test
```

### How It Works

1. **Action Usage**: The action uses a pre-built Docker image from GHCR (`ghcr.io/fulgas/reviewdog-action-checkov:1.2.0`) for fast execution
2. **CI Testing**: The CI workflow builds the Dockerfile from source and runs tests against it to validate changes
3. **Publishing**: When a release is created, the Docker image is built and published to GHCR with the release tag

This approach provides the best of both worlds:
- Users get fast action execution with pre-built images
- Developers can test Dockerfile changes before they're published

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

When contributing, please:
1. Follow the [semantic commit convention](CONTRIBUTING.md#commit-messages)
2. Test your changes locally
3. Update documentation as needed

## License

[MIT](LICENSE)

## Credits

- [Checkov](https://github.com/bridgecrewio/checkov) - IaC security scanner
- [reviewdog](https://github.com/reviewdog/reviewdog) - Automated code review tool