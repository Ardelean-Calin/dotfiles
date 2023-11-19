# This script simply starts a Windows 11 VM, as well as Looking Glass for easy
# access to it.
{ pkgs }:
pkgs.writeShellScriptBin "win11-start" ''
	virsh --connect qemu:///system start win11
	looking-glass-client
''
