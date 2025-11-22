# Checkov + Reviewdog GitHub Action

[![Marketplace](https://img.shields.io/badge/marketplace-Checkov%20%2B%20Reviewdog-blue)](https://github.com/marketplace/actions/run-checkov-with-reviewdog) [![GitHub release](https://img.shields.io/github/v/release/fulgas/reviewdog-action-checkov?label=release)](https://github.com/fulgas/reviewdog-action-checkov/releases)

A GitHub Action that runs [Checkov](https://www.checkov.io/) for Infrastructure as Code (IaC) security scanning and reports results to pull requests using [reviewdog](https://github.com/reviewdog/reviewdog).

## Features

- 🔍 Scan Terraform, CloudFormation, Kubernetes, and other IaC files
- 🐶 Inline PR comments with reviewdog
- 🎯 Configurable severity levels and filters
- 🚀 Easy to integrate into existing workflows
- 🐳 Available as Docker image on GHCR

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
        uses: fulgas/reviewdog-action-checkov@v1.0.4
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
        uses: fulgas/reviewdog-action-checkov@v1.0.4
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          level: warning
          filter_mode: nofilter
          fail_level: error
          working_directory: terraform/
          checkov_version: "2.3.4"
          skip_check: "CKV_AWS_1 CKV_AWS_2"
          framework: terraform,kubernetes
          flags: "--soft-fail"
```

### Using Docker Image from GHCR

```yaml
name: Checkov Review
on: [pull_request]

jobs:
  checkov:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/fulgas/reviewdog-action-checkov:1.0.4
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Checkov
        env:
          REVIEWDOG_GITHUB_API_TOKEN: ${{ secrets.github_token }}
          INPUT_REPORTER: github-pr-check
          INPUT_LEVEL: error
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
- uses: fulgas/reviewdog-action-checkov@v1.0.4
  with:
    github_token: ${{ secrets.github_token }}
    framework: terraform
```

### Skip specific checks

```yaml
- uses: fulgas/reviewdog-action-checkov@v1.0.4
  with:
    github_token: ${{ secrets.github_token }}
    skip_check: "CKV_AWS_1 CKV_AWS_18 CKV_AWS_19"
```

### Scan specific directory

```yaml
- uses: fulgas/reviewdog-action-checkov@v1.0.4
  with:
    github_token: ${{ secrets.github_token }}
    working_directory: infrastructure/
    target_dir: terraform/
```

### Fail on warnings

```yaml
- uses: fulgas/reviewdog-action-checkov@v1.0.4
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

```bash
docker run --rm \
  -v $(pwd):/github/workspace \
  -e GITHUB_TOKEN=your_token \
  -e INPUT_REPORTER=github-pr-check \
  reviewdog-action-checkov
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[MIT](LICENSE)

## Credits

- [Checkov](https://github.com/bridgecrewio/checkov) - IaC security scanner
- [reviewdog](https://github.com/reviewdog/reviewdog) - Automated code review tool