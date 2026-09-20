{ pulsar, pkgs }:

pkgs.writeShellScriptBin "ipulsar" ''
    set -e
    target="$PWD/Pulsar"

    if [ -e "$target" ]; then
        echo "Pulsar is already installed"
        exit 1
    fi

    echo "Installing Pulsar to $target..."
    cp -r ${pulsar} "$target"
    chmod -R u+w "$target"

    # the wrappers copied from the nix store would exec the ELF binaries from
    # the read-only store, making Pulsar use the store path as its data
    # directory and fail with "Read-only file system". Re-point them at the
    # local .bin-wrapped copies instead; the library paths inside the wrapper
    # stay nix store paths, which is fine since they are only read from.
    for bin in Interim.bin Modern.bin; do
        sed "s|${pulsar}/|$target/|g" "${pulsar}/$bin" > "$target/$bin"
        chmod +x "$target/$bin"
    done

    echo "Pulsar installation finished."
''
