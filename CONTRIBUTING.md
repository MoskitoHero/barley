# Contributing to Barley

We'd love for you to contribute to our source code and to make Barley even better than it is today! Here are the guidelines we'd like you to follow:

## 🧑‍🤝‍🧑 Code of Conduct

Help us keep Barley open and inclusive. Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## 🚀 Getting Started

1. Fork the repository on GitHub.
2. Clone the project to your own machine.
3. Create a branch with a descriptive name.

## 💻 Submitting a Pull Request

1. Commit your changes and push your branch to GitHub.
2. Make sure you follow coding standards defined in this document.
3. Submit a pull request to the `barley` repository.
4. Ensure the PR description clearly describes the problem and solution. Include the relevant issue number if applicable.

## ✔️ Code Review Process

Once you've submitted a pull request, it will be reviewed by the maintainers. We aim to provide feedback within a week. If the changes are approved, the PR will be merged.

## 👍 What we want

Barley basically started with one class and one module. We want to keep the Barley code performant and simple. We want to limit memory allocations, so we keep an eye on these as much as speed.

We welcome PRs that
- provide any form of improvement to the speed and memory usage of Barley. Use benchmarks to prove the benefits of your PRs
- make rails API design more robust - type-checking is a good example
- improve tooling, like minitest or rspec assertions, generators, etc.
- help with github actions

## 🥇 Coding Standards

Before submitting, make sure:
- New types are declared with RBS
- Changes are documented with Yard
- Code is tested (we use Minitest)
- `standardrb --fix` has been run against your code

## 🐛 Reporting Issues

We use GitHub Issues to track public bugs. Report a bug by opening a new issue.

## 🙏 Thanks

Thank you for considering contributing to Barley! Your help is greatly appreciated.
