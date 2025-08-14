# Librarium F.O.S. 📚

A local-first, neurodivergent-friendly shell environment for Termux, designed to be atomic, lightweight, and extensible.

## About The Project

Librarium F.O.S. (Fake Operating System) is an opinionated shell environment built for a specific setup: **Termux** running the **pacman** bootstrap and **Fish Shell**. It's not a new shell, but a complete framework for managing your entire command-line experience.

The goal is to create a setup that is powerful and deeply customizable, yet simple to manage and easy on the mind. Every component is designed around a set of core principles.

### Key Points

* **🎯 Local-First & Private**: Works completely offline. No data is ever sent to the cloud.
* **⚛️ Atomic**: Updates are applied in a single, all-or-nothing transaction, preventing a partially broken state.
* **🔗 Symlink-Based**: All configurations are managed in this single repository and safely linked into place by the installer.
* **🧠 Neurodivergent-Friendly**: A focus on clarity, low cognitive load, and clean interfaces to make the command line a more comfortable place.
* **🪶 Lightweight**: Built with performance in mind for a snappy experience on mobile devices.
* **🧩 Extensible**: Features a declarative system for managing system packages (`packages.txt`) and shell plugins (`plugins.txt`).
* **🔒 Secure by Design**: The built-in plugin manager uses a per-plugin lockfile system to ensure all dependencies are reproducible and secure.

***

## Usage

Librarium is managed by editing simple text files and then running the installer to apply the changes.

* **To manage system packages**: Add package names to the `packages.txt` file (e.g., `neovim` or `lua54 5.4.8-2`).
* **To manage shell plugins**: Add the plugin's GitHub repository (`user/repo`) to the `plugins.txt` file.
* **To add a custom command**: Place an executable script in the `bin/` directory.
* **To add a custom function**: Place a `.fish` file containing the function in the `lib/functions/` directory.

After making changes, simply run `./install.sh` from the project root to apply them.

***

## ⚠️ Disclaimer

This project is being developed with the assistance of a large language model (Google's Gemini). It is primarily a personal project built for my specific needs, workflow, and hardware. While it's open source, it is not intended as a general-purpose, drop-in solution for all users.

***

## 🗺️ Project Roadmap

This roadmap outlines the major development phases for the project.

### Phase 1: Foundational Framework (✅ Completed)
- [x] Establish core principles and project structure.
- [x] Develop a robust, modular installer script with logging and backups.
- [x] Implement symlinking for configs (`etc`), functions (`lib/functions`), and binaries (`bin`).

### Phase 2: Plugin & Package Management (✅ Completed)
- [x] Design and implement a custom plugin manager with caching.
- [x] Implement a per-plugin lockfile system (`var/plugin_lockfiles`).
- [x] Implement atomic installation of plugins via symlinking.
- [x] Integrate with `pacman` to manage system packages declaratively.

### Phase 3: Core Shell Features (🚧 Up Next)
- [ ] Design and implement a custom shell prompt (e.g., Starship).
- [ ] Add a library of useful default functions and aliases.
- [ ] Develop a simple theme system for colors and appearance.

### Phase 4: Advanced Extensibility (Future)
- [ ] Implement the Lua scripting API for high-performance extensions.
- [ ] Create documentation for the plugin system and Lua API.
