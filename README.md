# Librarium F.O.S. 📚

A local-first, neurodivergent-friendly shell environment for Termux, designed to be atomic, lightweight, and extensible.

> ### 🚧 Alpha Status 🚧
> This project is in the early stages of development. Expect frequent changes, potential bugs, and breaking updates. It is not yet recommended for general use.

> ### ⚠️ Disclaimer
> This project is being developed with the assistance of a large language model (Google's Gemini). It is primarily a personal project built for my specific needs, workflow, and hardware. While it's open source, it is not intended as a general-purpose, drop-in solution for all users.

***

## About The Project

Librarium F.O.S. (Fake Operating System) is an opinionated shell environment built for a specific setup: **Termux** running the **pacman** bootstrap and **Fish Shell**. It's not a new shell, but a complete framework for managing your entire command-line experience through a simple, declarative interface.

### Key Points

* **🎯 Local-First & Private**: Works completely offline. No data is ever sent to the cloud.
* **⚛️ Atomic**: Updates are applied in a single, all-or-nothing transaction, preventing a partially broken state.
* **🔗 Symlink-Based**: All configurations are managed in this single repository and safely linked into place by the installer.
* **🧠 Neurodivergent-Friendly**: A focus on clarity, low cognitive load, and clean interfaces to make the command line a more comfortable place.
* **🪶 Lightweight**: Built with performance in mind for a snappy experience on mobile devices.
* **🧩 Extensible**: Features a declarative system for managing system packages (`packages.txt`) and shell plugins (`plugins.txt`).
* **🔒 Secure by Design**: The built-in plugin manager uses a per-plugin lockfile system to ensure all dependencies are reproducible and secure.

***

## ✅ Prerequisites

1.  **Termux** with the **`pacman` bootstrap**.
2.  Core utilities **`git`** and **`curl`** installed.
3.  A **Nerd Font** (like Fira Code Nerd Font) installed and set in your Termux terminal for the prompt icons to display correctly.

***

## Usage

Librarium is managed through the `fos` command-line interface and by editing configuration files.

### Command-Line Interface
* **`fos plugin list`** (`p-list`): List configured plugins.
* **`fos plugin add <user/repo>`** (`p-add`): Add a new plugin.
* **`fos plugin remove <user/repo>`** (`p-remove`): Remove a plugin.
* **`fos plugin update [user/repo]`** (`p-update`): Update lockfiles for all or one plugin.
* **`update-fos`**: Applies all pending changes by running the main installer.

### Declarative Management
* **To manage system packages**: Add package names to the `packages.txt` file.
* **To add a custom command**: Place an executable script in the `bin/` directory.
* **To add a custom function**: Place a `.fish` file in `lib/functions/`.
* **To change the theme**: Add a `.properties` file to `share/themes/` and apply it with the `theme <theme_name>` command.

After making changes with the CLI or by editing files, run `update-fos` to apply them.

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
