# CraftX
> Unofficial Craft CMS Community

## Setup
To get [craftx.io][craftx] set up locally, you can follow the instructions below and make adjustments for your specific environment as you need.

## Requirements
- [Composer]
- [Vagrant]
- [VirtualBox][virtual-box] or [VMWare][vm-ware]

> Note that if you're using something like [MAMP] or [Valet] to host/serve your sites locally, you won't need VirtualBox or Vagrant.

## Technologies
- PHP 7.0|7.1
- MariaDB|MySQL
- Yarn or NPM
- VueJS
- Bulma

## Installing
1. Clone the repository:

```bash
git clone git@github.com:craftx/craftx.io.git {craftx.dev}`
```

> Replace `{craftx.dev}` with whatever project/site name you want to use.

2. From your project root, checkout the dev branch:
```bash
cd {craftx.dev}
git checkout dev
# or
git checkout -b dev
```

3. Install Craft and its composer dependencies, including a couple of the plugins:

```bash
composer install
```

4. Install all frontend dev dependencies:

```bash
yarn install
# or
npm install
```

5. Install _manual_ plugin dependencies

```bash
cd plugins/swipe && composer install
cd ../hangouts && composer install
```

> That should give you all the code needed to run Craft.

6. Duplicate `.env.example` as `.env` and set your database credentials
> There are only a couple of things you'll probably need to change.

7. Duplicate `config/local/general.example` as `config/local/general.php` and update it with your own settings

## Dashboard
If you'd like to access the dashboard locally, to see how fields/channels/sections have been set up.

1. Import `db/latest.sql` into your database
1. Use the following credentials:

```
email: support@craftx.io
username: craftx
password: 89F3H3n76QVuAM9RC[4[Y66X
```

## Running
This project is configured to be easy to set up if you want to use Vagrant/Homestead to host/serve locally.

You can run the following command from the root of the project:

```bash
vagrant up
```

This will spin up a new virtual machine and set everything up to run your project.

## No VM Please
If you don't want to run a virtual machine, no problem. Just set up your site as you normally would, using MAMP, Valet or whatever you use :)

## Windows Folks
A lot of these instructions probably won't apply or work _as is_, please let us know if you run into issues and will update as we go.

<!-- Link References -->
[composer]:https://getcomposer.org "Composer"
[craftx]:http://craftx.io "CraftX"
[vagrant]:https://www.vagrantup.com "Vagrant"
[valet]:https://laravel.com/docs/valet "Valet"
[virtual-box]:https://www.virtualbox.org "VirtualBox"
[vm-ware]:http://www.vmware.com "VMWare"
[mamp]:https://www.mamp.info "MAMP"
