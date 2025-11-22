# Contributing to reviewdog-action-checkov

Thank you for your interest in contributing to reviewdog-action-checkov! We welcome contributions from the community.

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How to Contribute

### Reporting Issues

- **Search existing issues** first to avoid duplicates
- Use the issue templates when available
- Include clear, detailed information:
  - Steps to reproduce
  - Expected vs actual behavior
  - Environment details (OS, Docker version, etc.)
  - Relevant logs or error messages

### Suggesting Enhancements

- Open an issue describing the enhancement
- Explain the use case and benefits
- Be open to discussion and feedback

### Pull Requests

1. **Fork the repository** and create a branch from `main`
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow existing code style and conventions
   - Keep changes focused and atomic
   - Write clear, descriptive commit messages

3. **Test your changes**
   - Ensure existing tests pass
   - Add new tests for new functionality
   - Test locally using the test workflows

4. **Update documentation**
   - Update README.md if needed
   - Add inline comments for complex logic
   - Update examples if behavior changes

5. **Submit the pull request**
   - Provide a clear description of changes
   - Reference any related issues
   - Be responsive to feedback and reviews

## Development Setup

### Prerequisites

- Docker
- Git
- A GitHub account

### Local Testing

Test the action locally:

```bash
# Build the Docker image
docker build -t reviewdog-action-checkov:test .

# Run tests
./test-locally.sh  # If you have a test script
```

Test in GitHub Actions:

```yaml
# Push to a branch and test via workflow
- uses: your-username/reviewdog-action-checkov@your-branch
  with:
    framework: terraform
    # ... other inputs
```

## Code Style

- Use shellcheck for shell scripts
- Follow existing formatting conventions
- Keep code readable and maintainable
- Add comments for non-obvious logic

## Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification for semantic commit messages. This helps with automated versioning and changelog generation.

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools and libraries
- **ci**: Changes to CI configuration files and scripts
- **build**: Changes that affect the build system or external dependencies
- **revert**: Reverts a previous commit

### Examples

```
feat: add support for custom Checkov flags
feat(reporter): add GitHub Actions annotations reporter
fix: resolve SARIF output parsing error
fix(entrypoint): handle missing GITHUB_OUTPUT file
docs: update README with new configuration options
docs(contributing): add semantic commit guidelines
test: add tests for kubernetes framework
ci: update workflow to test all frameworks
chore: update dependencies
refactor: simplify output handling logic
```

### Breaking Changes

Breaking changes should be indicated by adding `!` after the type/scope and including `BREAKING CHANGE:` in the footer:

```
feat!: change default reporter to local

BREAKING CHANGE: The default reporter has changed from github-pr-check to local.
Users who rely on the previous default should explicitly set the reporter input.
```

### Scope (Optional)

The scope provides additional context:
- `entrypoint`: Changes to entrypoint.sh
- `action`: Changes to action.yml
- `docker`: Changes to Dockerfile
- `ci`: Changes to CI workflows
- `docs`: Documentation changes

### Tips

- Keep the subject line under 72 characters
- Use imperative mood ("add" not "added" or "adds")
- Don't capitalize the first letter of the subject
- No period at the end of the subject line
- Separate subject from body with a blank line
- Use the body to explain what and why, not how
- Reference issues and pull requests in the footer

## Review Process

1. All submissions require review
2. Commit messages will be validated for semantic format
3. Maintainers will provide feedback
4. Address feedback and update your PR
5. Once approved, maintainers will merge

## Testing Requirements

- All new features should include tests
- Bug fixes should include regression tests
- Ensure tests pass before submitting PR

## Release Process

Releases are managed by maintainers:
- Semantic versioning is used (MAJOR.MINOR.PATCH)
- Release notes document changes
- Tags are created for each release

## Questions?

- Open a discussion on GitHub
- Check existing issues and documentation
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing! 🎉
