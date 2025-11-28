# [2.0.0](https://github.com/fulgas/reviewdog-action-checkov/compare/v1.2.0...v2.0.0) (2025-11-28)


* feat!: migrate to GHCR pre-built images with Dockerfile CI testing ([3fca159](https://github.com/fulgas/reviewdog-action-checkov/commit/3fca159d2cd6747bfeed9530f6fe497db3e11cc5))


### BREAKING CHANGES

* The action now uses pre-built Docker images from GHCR for
faster execution. The entrypoint receives inputs via environment variables
(INPUT_*) instead of command-line arguments.

Changes:
- Update action.yml to use docker://ghcr.io/fulgas/reviewdog-action-checkov:1.2.0
- Switch from args-based to environment variable-based input handling
- Update CI workflow to build and test from Dockerfile before publishing
- Ensure all framework tests run against locally built images
- Update README with new usage patterns and development workflow

Benefits:
- Faster action execution (no build time)
- CI still validates Dockerfile changes before publishing
- Users get stable, tested images
- Developers can iterate on Dockerfile with confidence

Migration guide for users:
- No action required for standard usage
- Custom Dockerfile users should switch to GHCR image or build their own

Signed-off-by: Nelson Silva <2473927+fulgas@users.noreply.github.com>

# [1.2.0](https://github.com/fulgas/reviewdog-action-checkov/compare/v1.1.0...v1.2.0) (2025-11-25)


### Features

* update dependencies ([fc51851](https://github.com/fulgas/reviewdog-action-checkov/commit/fc51851707f7f19b5fbaf5aefa2c6bacd61a6aff))

# [1.1.0](https://github.com/fulgas/reviewdog-action-checkov/compare/v1.0.4...v1.1.0) (2025-11-22)


### Features

* pin docker images ([84521ec](https://github.com/fulgas/reviewdog-action-checkov/commit/84521ec244a976d354bae6ffd05b1585b7adf8df))

## [1.0.4](https://github.com/fulgas/reviewdog-action-checkov/compare/v1.0.3...v1.0.4) (2025-11-22)


### Bug Fixes

* add tests ([017114b](https://github.com/fulgas/reviewdog-action-checkov/commit/017114bcc95e13c5e6f27dbf96d5473b822c4a79))

## [1.0.3](https://github.com/fulgas/reviewdog-action-checkov/compare/v1.0.2...v1.0.3) (2025-11-22)


### Bug Fixes

* improve dockerfile ([6b53616](https://github.com/fulgas/reviewdog-action-checkov/commit/6b53616642bbe56c614ff85ad1ac64d1284022d9))

## [1.0.2](https://github.com/fulgas/reviewdog-action-checkov/compare/v1.0.1...v1.0.2) (2025-11-22)


### Bug Fixes

* improve dynamic args for checkov ([0674942](https://github.com/fulgas/reviewdog-action-checkov/commit/0674942334bc56a59dcb764e23bbc9329ebbc37a))

## [1.0.1](https://github.com/fulgas/reviewdog-action-checkov/compare/v1.0.0...v1.0.1) (2025-11-21)


### Bug Fixes

* set correct action name ([7bcb5a5](https://github.com/fulgas/reviewdog-action-checkov/commit/7bcb5a5183e471c04bd2bd80a849f474e79ee6f8))

# 1.0.0 (2025-11-21)


### Features

* add first release on reviewdog-action-checkov ([5010802](https://github.com/fulgas/reviewdog-action-checkov/commit/50108021d330eb4fd78102924d37ac887cea7fb7))
