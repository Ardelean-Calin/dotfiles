let
  # RTX 3070 Ti
  gpuIDs = [
    "10de:2488" # Graphics
    "10de:228b" # Audio
  ];
in
  {
    pkgs,
    lib,
    ...
  }: {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"
      ];

      kernelParams =
        [
          # enable IOMMU
          "amd_iommu=on"
          # "pcie_acs_override=downstream"
        ]
        ++ [("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)];
    };

    hardware.opengl.enable = true;
    # Enable libvirt virtualization
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    systemd.tmpfiles.rules = [
      "f	/dev/shm/looking-glass	0660	calin	kvm	-"
    ];

    # Install virtualisation-related packages
    environment.systemPackages = with pkgs; [
      virt-manager
    ];
  }
