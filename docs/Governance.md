# Project Governance

## Roles and Personnel

The eBPF for Windows Sample Program project currently uses the following roles, listed
in order of increasing permission:

* Contributor
* Maintainer
* Project Admin

### Contributor

The ability to read, clone, and contribute issues or
pull requests is open to the public.

Personnel: anyone

Minimum Requirements: (none)

Responsibilities: (none)

### Maintainer

A maintainer can also merge pull requests.
This corresponds to the "Write" role in github.

Personnel: @Alan-Jowett

Minimum Requirements:
* Has submitted multiple pull requests that have been merged
* Has provided feedback on multiple pull requests from others
* Has demonstrated an understanding of the codebase
* Is approved by the existing Project Admin

Responsibilities:
* Review pull requests from others.
* Merge pull requests once tests pass and sufficient approvals exist.

### Project Admin

An admin can also assign people to each of these
roles, and have full access to all github settings.
This corresponds to the "Admin" role in github.

Personnel: @Alan-Jowett

Minimum Requirements:
* Has acted as a maintainer
* Understands the github Admin settings

Responsibilities:
* Manage github settings such as branch protection rules and repository secrets.
* Review and approve new maintainers.

## Contributing Guidelines

### Pull Request Reviews

Pull requests should be reviewed for:

* Technical correctness and code quality
* Adherence to coding conventions outlined in the [Development Guide](DevelopmentGuide.md)
* Appropriate test coverage for new functionality
* Documentation updates for user-visible changes
* Compatibility with the eBPF for Windows ecosystem

### Code Quality Standards

All code submissions must:
- Follow the project's coding conventions
- Include appropriate license headers
- Pass automated formatting checks
- Include tests for new functionality
- Maintain or improve existing test coverage