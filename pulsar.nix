{ stdenv, lib, pkgs}:
let
    # for plugins
    runtimeLibs = with pkgs; [
        gccNGPackages_15.libstdcxx
        dotnet-runtime_10
        zlib
        libx11
        libxext
        wayland
        libxkbcommon
        vulkan-loader
        libopus
        pulseaudio
    ];
    libraryPath = lib.makeLibraryPath runtimeLibs;
    dotnet-runtime_10 = pkgs.dotnet-runtime_10;
in
stdenv.mkDerivation rec {
    pname = "Pulsar";
    version = "2.4.2";

    src = fetchTarball {
        url = "https://github.com/SpaceGT/Pulsar/releases/download/v${version}/pulsar-v${version}-linux-x64.tar.gz";
        sha256 = "16zdshc1hd7sjkpz6kzh1vdbpj86i9cm1z12ssnb7ghsh9pjzfbw";
    };

    # for Pulsar
    buildInputs = with pkgs; [
        fontconfig
        gccNGPackages_15.libstdcxx
        libgcc
        libx11
        libICE
        libsm
    ];

    nativeBuildInputs = with pkgs; [
        makeWrapper
        autoPatchelfHook
    ];

    dontBuild = true;

    passthru = {
        libraryPath = libraryPath;
    };

    installPhase = ''
        mkdir -p $out
        cp -r * $out
        
        ln -s ${pkgs.libx11}/lib/libX11.so.6 \
        $out/Libraries/Interface/libX11.so.6
        ln -s ${pkgs.libICE}/lib/libICE.so.6 \
        $out/Libraries/Interface/libICE.so.6
        ln -s ${pkgs.libsm}/lib/libSM.so.6 \
        $out/Libraries/Interface/libSM.so.6

        wrapProgram $out/Interim.bin --prefix LD_LIBRARY_PATH : ${libraryPath} --prefix DOTNET_ROOT : ${dotnet-runtime_10}/share/dotnet
        wrapProgram $out/Modern.bin --prefix LD_LIBRARY_PATH : ${libraryPath}
    '';

    meta = with lib; {
        description = "A plugin and mod loader for Space Engineers.";
        homepage = "https://github.com/SpaceGT/Pulsar";
        license = licenses.mit;
        platform = platforms.x86_64;
    };
}
