# Contributing to usmart

We appreciate your interest in contributing to usmart! This document provides guidelines and instructions for contributing to the project.

---

## Code of Conduct

All contributors are expected to uphold our Code of Conduct. Please report unacceptable behavior to the project maintainers.

---

## Ways to Contribute

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, include as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps to reproduce the problem
- Provide specific examples to demonstrate the steps
- Describe the behavior you observed after following the steps
- Explain which behavior you expected to see instead and why
- Include screenshots and animated GIFs if possible
- Include your environment details (Flutter version, device type, OS)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- Use a clear and descriptive title
- Provide a step-by-step description of the suggested enhancement
- Provide specific examples to demonstrate the steps
- Describe the current behavior and the expected behavior
- Explain why this enhancement would be useful

### Pull Requests

- Fill in the required template
- Follow the Dart styleguide
- Include appropriate test cases
- Update documentation as needed
- End all files with a newline

---

## Development Setup

### Prerequisites

- Flutter 3.10.7+
- Dart 3.10.7+
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)

### Setting Up Your Development Environment

1. Fork the repository on GitHub
2. Clone your fork locally:
```bash
git clone https://github.com/YOUR_USERNAME/usmart.git
cd usmart
```

3. Add the upstream repository:
```bash
git remote add upstream https://github.com/ORIGINAL_OWNER/usmart.git
```

4. Install dependencies:
```bash
flutter pub get
```

5. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

6. Verify everything works:
```bash
flutter test
flutter analyze
```

---

## Making Changes

### Create a Branch

Create a new branch for your feature or fix:
```bash
git checkout -b feature/your-feature-name
```

Use descriptive branch names:
- `feature/add-weather-integration`
- `bugfix/fix-umbrella-lag`
- `docs/update-readme`

### Code Style

Follow the Dart Style Guide:
- Use meaningful variable and function names
- Limit lines to 80 characters where practical
- Use meaningful comments for complex logic
- Format code using `dart format`
- Run analysis using `flutter analyze`

### Commit Messages

Use clear and descriptive commit messages:
```
Add umbrella position sync feature

- Synchronize umbrella position with device state
- Add position polling interval configuration
- Update state provider with new position stream
- Add tests for position synchronization

Fixes #123
```

### Testing

Add tests for new features:
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

Ensure all tests pass before submitting a PR.

---

## Submitting Changes

### Before Submitting

1. Rebase your branch on the latest main:
```bash
git fetch upstream
git rebase upstream/main
```

2. Run the full test suite:
```bash
flutter test
```

3. Run code analysis:
```bash
flutter analyze
dart fix --apply
dart format lib/
```

4. Push your changes:
```bash
git push origin feature/your-feature-name
```

### Creating a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Set the base repository to `ORIGINAL_OWNER/usmart` and base branch to `main`
4. Set head repository to your fork and branch to your feature branch
5. Fill in the PR template with details about your changes
6. Link related issues using `Fixes #123` or `Closes #123`
7. Request review from maintainers

### PR Guidelines

- One feature or bugfix per pull request
- Include tests for new functionality
- Update documentation if needed
- Keep commits atomic and well-organized
- Don't include unrelated changes
- Ensure CI/CD checks pass

---

## Review Process

### What to Expect

- A maintainer will review your PR within a few days
- They may request changes or ask clarifying questions
- Be responsive to feedback and make requested changes promptly
- Once approved, a maintainer will merge your PR

### Tips for Getting Your PR Merged Faster

- Follow the guidelines above
- Write clear and descriptive commit messages
- Include tests and documentation
- Respond to feedback promptly
- Keep PRs focused and manageable in size

---

## Architecture Guidelines

When contributing new features, please follow these architectural principles:

### Layered Architecture

```
Presentation Layer (UI Components)
    |
State Management Layer (Riverpod Providers)
    |
Domain Layer (Business Logic)
    |
Infrastructure Layer (Device Interface, Services)
```

### Adding New Features

1. Create feature directory: `lib/features/your_feature/`
2. Organize as: `presentation/`, `models/`, `repository/` (if needed)
3. Create Riverpod providers in `lib/state/`
4. Add routes to `lib/core/navigation/app_router.dart`
5. Follow immutability patterns for state classes

### Device Interface Implementation

If implementing new device functionality:
1. Add method to `UmbrellaDeviceInterface`
2. Implement in both `FakeUmbrellaDevice` and `ESP32UmbrellaDevice`
3. Add corresponding state model to `UmbrellaDeviceState`
4. Create provider for new state in `lib/state/`
5. Create UI components to display/control feature

---

## Documentation

### Code Documentation

- Add documentation comments to public APIs
- Use triple-slash (`///`) for public documentation
- Include parameter descriptions and return types
- Provide examples where helpful

Example:
```dart
/// Opens the umbrella with optional animation
///
/// Throws [DeviceNotConnectedException] if device is not connected.
/// Throws [UmbrellaOperationException] if operation fails.
///
/// Parameters:
///   - [duration] - Animation duration (default: 500ms)
///
/// Example:
/// ```dart
/// await device.openUmbrella(duration: Duration(milliseconds: 800));
/// ```
Future<void> openUmbrella({Duration duration = const Duration(milliseconds: 500)});
```

### README Updates

- Update README.md when adding significant features
- Document new dependencies in Dependencies section
- Add new features to Feature list
- Update architecture diagrams if needed

---

## Release Process

Maintainers will handle releases. When a release is ready:
1. Increment version in `pubspec.yaml`
2. Update CHANGELOG.md
3. Create GitHub release with version tag
4. Publish to pub.dev (if applicable)

---

## Getting Help

- Check existing issues and discussions
- Ask questions in GitHub Discussions
- Reach out to maintainers on GitHub

---

## Recognition

Contributors will be recognized in:
- Project README
- GitHub contributors page
- Release notes for significant contributions

---

Thank you for contributing to usmart!
