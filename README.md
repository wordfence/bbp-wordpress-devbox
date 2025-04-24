# Devbox WordPress 

Devbox provides an isolated and reproducible development environment. Instead of virtual machines or containers, it uses the Nix package manager. Learn more about Devbox [here](https://www.jetpack.io/devbox).

* Takes less than a minute to stand up an instance on your local machine
* Better usage of system resources
* WordPress is super fast
* Can use locally installed apps/tools/filesystem
* Easy to create multiple instances with slight variations like different WordPress version or different database.
* No conflicts with local software

This repository contains a `devbox.json` configuration file to set up a local WordPress development environment with MariaDB, Apache, PHP, and Xdebug. Optionally, Devbox scripts that add users with each privilege level, install WooCommerce (including demo data), and install Elementor have been added.

## Prerequisites

- [Devbox](https://www.jetpack.io/devbox/docs/quickstart/#install-devbox): Follow the installation guide to get Devbox installed on your system. Linux, macOS, and Windows (via WSL2)
- Git (Optional if you choose to clone the repository, or you can just download the files in the repo to a new folder)

## Getting Started

1. **Get the Configuration**: Clone this repository.

   ```bash
   git clone <repository-url> your-folder-name
   ```

2. **Navigate to the Directory**: Change to the directory you created.

   ```bash
   cd your-folder-name
   ```
3. **Change the Default Passwords**: Edit `devbox.json` and change the `DB_PASSWORD` and `WP_ADMIN_PASSWORD` if you don't want it to be `password`. Take note of the default username (`admin`).

4. **Changing from Apache to NGINX**: Edit `devbox.json` and change the `apache@latest` line under `packages` to `nginx@latest`. Change `WEBSERVER` under `env` from `apache` to `nginx`.

5. **Start Devbox Shell**: Run the following command to start the Devbox shell. This will install all the required packages defined in the `devbox.json` file.

   ```bash
   devbox shell
   ```

> NOTE: If you switched the webserver in `devbox.json` to NGINX, run `devbox run setup_nginx` before you continue.

6. **Start Services**: When the installation of packages is complete, in the same terminal window, run the following command to start the required services (i.e., Apache, MariaDB, etc.).

   ```bash
   devbox services start 
   ```

7. **Set Up the Development Environment**: Once all services are running, in the same terminal, run the following command to set up the WordPress development environment.

   ```bash
   devbox run setup_devbox
   ```

8. **Restarting Services**: We'll need to restart services so the permalink structure changes (From `Plain` to `Post name`) take effect.

   ```bash
   devbox services stop
   devbox services up
   ```

> NOTE: `devbox services start` and `devbox services stop` starts and stops services in the background, leaving the current terminal session free. `devbox services up` gives you a nice visual display where you can start/restart individual (or all) services and see log data for each service. This is why we choose to use it in our final command to launch our services.

> NOTE 2: `devbox services restart` doesn't seem to have the desired effect of causing the modified permalink structure to take effect.

9. **Optional Scripts**: You can optionally run the following scripts (wihin the same folder that contains your `devbox.json`) to add users, install WooCommerce, install Elementor, etc.

   - Add Users: `devbox run setup_users`
   - Install WooCommerce: `devbox run setup_woocommerce`
   - Install Elementor: `devbox run setup_elementor`

10. **Access WordPress**: Navigate to `http://localhost:8081`. You can log in using the admin credentials defined in the `devbox.json` file.

## Configuration

The `devbox.json` file contains the configuration for the development environment. You can customize these settings according to your needs.

The `scripts` directory contains bash scripts to set up and configure WordPress, its dependencies, as well as optional scripts (e.g. WooCommerce install with Storefront theme and demo products).

The `nginx` directory contains configuration files for use when NGINX is selected as the web server.

## Default Configuration Notes

* The latest versions of Apache, MariaDB, PHP, WordPress, WP-CLI, and AdminerEvo are used. You can adjust the installed version by changing the relevant line under the `packages` section of `devbox.json`. For example, if you wanted to install PHP 7.4, you would change `php@latest` to `php@7.4`. Then, you'd also adjust the related extensions: `php82Extensions.xdebug@latest` and `php82Packages.composer@latest` to `php74Extensions.xdebug@latest` and `php74Packages.composer@latest`, respectively.

* AdminerEvo (a web-based database management tool that uses only one PHP file) can be found at `http://localhost:<port>/adminer.php`. Use `127.0.0.1` instead of `localhost` in the `Server` field.

## Troubleshooting / FAQ

**Problem:** On MacOS on Apple Silicon, I get an error like: `error: builder for '/nix/store/<package>' failederror: builder for '/nix/store/aqs5pvir19i6i1m3rcz9cjd5c90hkzz3-php-ctype-8.4.6.drv' failed with exit code 2;`

**Solution:** Instead of using `<package>@latest` in `devbox.json`, use an older version of the offending package. You can find these versions by running `devbox search <package_name>`. For example, you might change `php84Packages.composer@latest` in `devbox.json` to `php84Packages.composer@2.8.4` or `wp-cli@latest` to `wp-cli@2.9.0`.

**Problem:** A required port is in use (e.g., 8081 for the web server or 8082 for the php-fpm).

**Solution:** Figure out what's running on that port (e.g. `sudo lsof -i :8081`) and shut it down if possible or use another port in `devbox.json`.
