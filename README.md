# Pulsar NixOS Flake

[Pulsar](https://github.com/SpaceGT/Pulsar) is a plugin manager for Space Engineers.

**NOTE:** So far only Space Engineers 1 seems to work with it.

Also, contacting me or committing pull requests is always welcome.

# Usage

In order to install Pulsar you must clone the repository and run the installer:

    git clone https://github.com/Avo-Catto/PulsarFlake.git
    cd PulsarFlake
    nix run .

The installer will copy the Pulsar files to the current working directory into a new Pulsar directory from where you can access it.

> Info: It is necessary for Pulsar to be run in a mutable file system. This allows users to add plugins, which modifies the Pulsar directory at runtime.

In steam you need to disable Proton for Space Engineers and set the launch option to:

    /path/to/PulsarFlake/Pulsar/Interim.bin %command%

Note that you need to replace the path with the actual path of your Pulsar installation and replace Interim.bin with Modern.bin for Space Engineers 2.

# Plugins

I personally do not care about plugins therefore please refer to the [official Pulsar repository](https://github.com/SpaceGT/Pulsar) for further information on how to add plugins.

If plugins require libraries and throw errors about not being able to find them, please add the corresponding packages to the runtimeLibs package list at the top of pulsar.nix.
This also results in you requiring to rebuild the installation. Currently you would need to delete the entire Pulsar directory and run `nix run .` in order to do so.

# How it works technically

The Pulsar binaries are being patched via autoPatchelfHook, while other libraries required by third party packages are symlinked in the Libraries directory of Pulsar.
In order to provide Plugins with the necessary libraries without having to package all of them separately, LD_LIBRARY_PATH is being specified and the binaries are being wrapped, 
allowing the Plugins to find the necessary libraries.

# Credits and Licensing

Pulsar is developed by [SpaceGT/Pulsar](https://github.com/SpaceGT/Pulsar) and is licensed under the MIT License.

PulsarFlake is an independent NixOS packaging project and is not
affiliated with the Pulsar project.
