# Librarium S.I.D.E. - CLI Reference

This document provides a detailed reference for the `side` command-line interface.

## Main Command
The primary command is `side_interface.sh`, available through the `side` alias.

---

## `side apply`
Applies all configurations by running the main installer script. This is the command to run after making changes to your configuration files (`plugins.txt`, `packages.txt`, etc.).

* **Alias**: `side-apply`
* **Usage**: `side apply`

---

## `side theme`
Manages the terminal's color theme.

### `theme list`
Lists all available theme files located in `share/themes/`.

* **Alias**: `t-list`
* **Usage**: `side theme list`

### `theme set`
Applies a specific theme.

* **Alias**: `t-set <theme_name>`
* **Usage**: `side theme set <theme_name>`

---

## `side plugin`
Manages Fish shell plugins.

### `plugin list`
Lists all plugins currently in your `plugins.txt` file.

* **Alias**: `p-list`
* **Usage**: `side plugin list`

### `plugin add`
Adds a new plugin to your `plugins.txt` file.

* **Alias**: `p-add <user/repo>`
* **Usage**: `side plugin add <user/repo>`

### `plugin remove`
Removes a plugin from your `plugins.txt` file.

* **Alias**: `p-remove <user/repo>`
* **Usage**: `side plugin remove <user/repo>`

### `plugin update`
Updates the lockfiles for plugins to their latest versions from GitHub. Can update all plugins or a single one.

* **Alias**: `p-update [user/repo]`
* **Usage**: `side plugin update [user/repo]`

### `plugin compile`
(Future) Compiles plugins into optimized packs for faster loading.

* **Alias**: `p-compile`
* **Usage**: `side plugin compile`

