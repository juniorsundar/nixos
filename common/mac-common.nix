{
    flakeSelf,
        config,
        pkgs,
        ...
}: {
    system.configurationRevision = flakeSelf.rev or flakeSelf.dirtyRev or null;
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
}


