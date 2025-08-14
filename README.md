# Librarium F.O.S. 📚

NOTE!!!: HEAVY WIP

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
* **🧩 Extensible**: Designed to be extended with custom shell scripts, functions, and a built-in plugin manager. A Lua-based API is planned for high-performance extensions.
* **🔒 Secure by Design**: Built with privacy and security in mind, with a custom, lockfile-based plugin system instead of relying on third-party managers.

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
- [x] Design a custom plugin manager concept.

### Phase 2: Plugin & Package Management (🚧 In Progress)
- [x] Implement a per-plugin lockfile system (`var/plugin_lockfiles`).
- [x] Implement version locking and duplicate checking for plugins.
- [ ] Implement plugin installation from a local cache for speed and offline use.
- [ ] Implement atomic installation of plugins via symlinking from the cache.
- [ ] Integrate with `pacman` and `glibc-runner` for managing system-level dependencies.

### Phase 3: Core Shell Features (Next Up)
- [ ] Design and implement a custom shell prompt (e.g., Starship).
- [ ] Add a library of useful default functions and aliases.
- [ ] Develop a simple theme system for colors and appearance.

### Phase 4: Advanced Extensibility (Future)
- [ ] Implement the Lua scripting API for high-performance extensions.
- [ ] Create documentation for the plugin system and Lua API.


