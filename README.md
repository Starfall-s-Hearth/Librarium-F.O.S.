# Librarium S.I.D.E. 💡

A Smart Integrated Dev Environment for the Termux command line.

> ### 🚧 Alpha Status 🚧
> This project is in the early stages of development and is currently undergoing a significant rewrite and rebrand. Expect frequent changes, potential bugs, and breaking updates. It is not yet recommended for general use.

> ### ⚠️ Disclaimer
> This project is being developed with the assistance of a large language model (Google's Gemini). It is primarily a personal project built for my specific needs, workflow, and hardware. While it's open source, it is not intended as a general-purpose, drop-in solution for all users.

***

## About The Project

Librarium S.I.D.E. (Smart Integrated Dev Environment) is a framework that transforms your terminal into an intelligent, integrated development environment. It's built for a specific setup: **Termux** running the **pacman** bootstrap and **Fish Shell**.

Instead of being a passive shell, S.I.D.E. acts as an active assistant that manages your entire toolchain, automates your workflow, and provides context-aware information, much like a graphical IDE.

### Key Points

* **🎯 Local-First & Private**: Works completely offline. No data is ever sent to the cloud.
* **⚛️ Atomic**: Updates are applied in a single, all-or-nothing transaction, preventing a partially broken state.
* **🔗 Symlink-Based**: All configurations are managed in this single repository and safely linked into place by the installer.
* **🧠 Neurodivergent-Friendly**: A focus on clarity, low cognitive load, and clean interfaces to make the command line a more comfortable place.
* **🪶 Lightweight**: Built with performance in mind for a snappy experience on mobile devices.
* **🧩 Extensible**: Manage system packages and shell extensions through declarative text files and a simple command-line interface.
* **🔒 Secure by Design**: The built-in extension manager uses a per-plugin lockfile system to ensure all dependencies are reproducible and secure.

***

## ✅ Prerequisites

1.  **Termux** with the **`pacman` bootstrap**.
2.  Core utilities **`git`** and **`curl`** installed.
3.  A **Nerd Font** installed and set in your Termux terminal for the prompt icons to display correctly.

***

## Usage

Manage your S.I.D.E. with the `fos` command-line interface and by editing simple configuration files.

### Command-Line Interface
* **`fos plugin list`** (`p-list`): List configured plugins.
* **`fos plugin add <user/repo>`** (`p-add`): Add a new plugin.
* **`fos plugin remove <user/repo>`** (`p-remove`): Remove a plugin.
* **`fos plugin update [user/repo]`** (`p-update`): Update lockfiles for all or one plugin.
* **`update-fos`**: Applies all pending changes by running the main installer.

### Declarative Management
* **To manage system packages**: Add package names to `packages.txt`.
* **To add a custom command**: Place an executable script in the `bin/` directory.
* **To add a custom function**: Place a `.fish` file in `lib/functions/`.
* **To change the theme**: Add a `.properties` file to `share/themes/` and apply it with the `theme <theme_name>` command.

After making changes, run `update-fos` to apply them.

***

## 🗺️ Project Roadmap

### Phase 1: Foundational Framework (✅ Completed)
- [x] Establish core principles and project structure.
- [x] Develop a robust, modular installer script.
- [x] Implement symlinking for configs, functions, and binaries.

### Phase 2: Plugin & Package Management (✅ Completed)
- [x] Design and implement a custom plugin manager with caching.
- [x] Implement a per-plugin lockfile system.
- [x] Implement atomic installation of plugins via symlinking.
- [x] Integrate with `pacman` to manage system packages declaratively.

### Phase 3: Core Shell Features (✅ Completed)
- [x] Design and implement a custom, Geometry-style shell prompt.
- [x] Add a library of useful default functions and aliases.
- [x] Develop a Termux-native theme system.

### Phase 4: Advanced Extensibility (Future)
- [ ] Implement the Lua scripting API for high-performance extensions.
- [ ] Create documentation for the plugin system and Lua API.
