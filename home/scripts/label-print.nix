{pkgs, ...}:
pkgs.writeShellApplication {
  name = "label-print";
  runtimeInputs = with pkgs; [python311Packages.brother-ql];
  text = ''
    brother_ql -b pyusb -m QL-800 -p usb://0x04f9:0x209b print --red -l 62red -r 90 $1
  '';
}
