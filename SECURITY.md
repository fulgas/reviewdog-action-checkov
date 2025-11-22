# Security Policy

## Reporting a Vulnerability

We take the security of reviewdog-action-checkov seriously. If you discover a security vulnerability, please report it responsibly.

### How to Report

**Please DO NOT open a public GitHub issue for security vulnerabilities.**

Instead, please use GitHub Security Advisories:

1. Go to the [Security tab](../../security/advisories)
2. Click "Report a vulnerability"
3. Fill out the form with details

This ensures the vulnerability is reported privately and securely.

### What to Include

Please include as much information as possible:

- Type of vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)
- Your contact information for follow-up

### What to Expect

- **Initial Response**: Within 48 hours
- **Status Update**: Within 5 business days
- **Fix Timeline**: Depends on severity and complexity

We will:
1. Confirm receipt of your report
2. Assess the vulnerability
3. Develop and test a fix
4. Release a security patch
5. Publicly disclose the vulnerability (with credit to you, if desired)

## Supported Versions

We provide security updates for:

| Version | Supported          |
| ------- | ------------------ |
| latest (main branch) | :white_check_mark: |
| Tagged releases | :white_check_mark: |

## Security Best Practices

When using this action:

1. **Token Security**
    - Always use `${{ secrets.GITHUB_TOKEN }}`, never hardcode tokens
    - Use minimum required permissions
    - Rotate tokens regularly

2. **Docker Image**
    - We build from source in CI
    - Review the Dockerfile before using
    - Pin to specific versions/tags for production use

3. **Supply Chain**
    - Review dependencies in Dockerfile
    - Monitor for updates to base images
    - Check Checkov and Reviewdog versions

4. **Code Scanning**
    - This action scans Infrastructure as Code
    - Review findings and fix high-severity issues promptly

## Known Security Considerations

### Docker Socket Access

This action requires Docker socket access (`/var/run/docker.sock`) to run Checkov. This grants significant permissions. Only use this action in trusted CI/CD environments.

### Third-party Dependencies

This action depends on:
- Checkov (by Bridgecrew/Prisma Cloud)
- Reviewdog (by reviewdog/reviewdog)

Review their security policies:
- [Checkov Security](https://github.com/bridgecrewio/checkov/security)
- [Reviewdog Security](https://github.com/reviewdog/reviewdog/security)

## Security Updates

Security fixes are released as soon as possible. Subscribe to:
- GitHub Security Advisories for this repo
- GitHub release notifications
- Watch this repository for updates

## Acknowledgments

We appreciate responsible disclosure and will credit researchers who report valid vulnerabilities (unless they prefer to remain anonymous).

---

Thank you for helping keep reviewdog-action-checkov secure! 🔒