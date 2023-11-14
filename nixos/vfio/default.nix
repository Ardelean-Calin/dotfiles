{pkgs, ...}: {
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"

      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    kernelParams = [
      # enable IOMMU
      "amd_iommu=on"
    ];
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
