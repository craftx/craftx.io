# CraftX
> Craft Training for Busy Developers

## Setup
To get [craftx.io][craftx] set up locally, you can follow the instructions below and make adjustments for your specific environment as you need.

## Requirements
- [Composer]
- [Vagrant]
- [VirtualBox][virtual-box] or [VMWare][vm-ware]

> Note that if you're using something like [MAMP] or [Valet] to host/server your sites locally, you won't need VirtualBox or Vagrant.

## Installing
This project is configured to be easy to set up if you want to use Vagrant / Homestead to host/serve locally.

```bash
# path/to/craftx.dev
vagrant up
```

This will spin up a new virtual machine and set everything up to run your project.

<!-- Link References -->
[composer]:https://getcomposer.org "Composer"
[craftx]:http://craftx.io "CraftX"
[vagrant]:https://www.vagrantup.com "Vagrant"
[valet]:https://laravel.com/docs/valet "Valet"
[virtual-box]:https://www.virtualbox.org "VirtualBox"
[vm-ware]:http://www.vmware.com "VMWare"
[mamp]:https://www.mamp.info "MAMP"
