# CHEZMOI.md

## Overview

This repository utilizes [chezmoi](https://chezmoi.io/) to manage and synchronize dotfiles across multiple machines. chezmoi is a robust tool that facilitates the management of personal configuration files, ensuring consistency and security across diverse environments.

## Dependencies

Before setting up and applying the configurations from this repository, ensure the following dependencies are installed on your system:

### 1. **chezmoi**
The primary tool for managing dotfiles.

**Installation**:
- On macOS (using Homebrew):
  ```bash
  brew install chezmoi
  ```

	•	On Linux (using Homebrew):

brew install chezmoi


	•	On Linux (official script):

sh -c "$(curl -fsLS get.chezmoi.io)"


	•	Official installation guide

2. zsh

The configurations are tailored for the Zsh shell. Ensure Zsh is installed and set as your default shell.

Installation:
	•	On macOS (using Homebrew):

```bash
brew install zsh
```

	•	On Debian-based systems:

```bash
sudo apt install zsh
```


	•	On Red Hat-based systems:

```bash
sudo dnf install zsh
```



3. Additional Tools

Some dotfiles may depend on external tools or plugins. Review .zshrc and other configs to identify these dependencies.

Repository Structure
	•	.chezmoiignore: Files/dirs chezmoi should ignore.
	•	dot_zprofile: Zsh login shell script.
	•	dot_zshrc: Zsh interactive shell config.
	•	dot_config/: Extra config files managed by chezmoi.

Setup Instructions

1. Initialize chezmoi

Clone and apply your dotfiles:

chezmoi init --apply https://github.com/rtdevnet/chezmoi-dotfiles.git

--apply immediately applies the dotfiles after initialization.

2. Review and Apply Changes

Preview the changes:

chezmoi diff

Apply them:

chezmoi apply

3. Manage New Dotfiles

To add a new file:

chezmoi add /path/to/dotfile

Notes and Recommendations
	•	Secrets Management: Avoid committing secrets directly. Use chezmoi’s secret management.
	•	Machine-Specific Configs: Use templating (if, eq, etc.) to handle host-specific settings.
	•	Regular Updates: Keep your system in sync:

chezmoi update


	•	Docs: Explore the official documentation for advanced usage.

Outstanding Tasks
	•	Documentation: Add explanations for each config file and tool used.
	•	Dependencies: List all required tools and plugins explicitly.
	•	Testing: Validate configs across different environments.
	•	Automation: Script the installation of dependencies for faster onboarding.

⸻
