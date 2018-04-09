# edx.scripts

This repository contains fully documented and parameterized bash script that are intended to help you fill in the blanks on basic Open edX system administration and devops tasks. You'll find complete how-to guides for each of these scripts [on my personal blog](https://blog.lawrencemcdaniel.com/)

## Scripts Included

### edx.backup.sh
Use this script to create a complete backup of your Open edX installation saved to AWS S3. Backs up all MySQL and MongoDB databases and archives these into a single compressed tarball. The script also works with a properly-configured AWS S3 bucket and AWS Command Line Interface (CLI) to permanently archive your backup.

### edx.compile-assets.sh
In many cases, modifications to the Open edX user interface require recompiling assets so that your changes appear in the production environment. This script initiates the asset compilation process, which takes around 10 minutes to complete. Your Open edX platform will be unavailable during the compilation process.

### edx.compile-language.sh
If you administer a non-English platform then any changes that you make to the language translation
files require a recompilation of the language pack. This script initiates the recompilation process.

### edx.platform-install.sh
These are the complete set of commands necessary to raise a new Open edX Native installation
on a fresh build of Ubuntu 16.04.

### edx.platform-migrations.sh
Initiates database migrations, a Django-specific deployment process whereby updates to database table, field and relationships are deduced by programmatically analyzing django/python objects. This process is almost always taken care of for you via the Ansible Playbooks. You'd need to run this script if, for example, an automated platform upgrade script stalled.

### edx.platform-restart.sh
Restarts your Open edX platform without having to completely reboot the server.

### edx.platform-stop.sh
Stops all Open edX services.

### edx.platform-upgrade.sh
Backs up your current Open edX codebase and then reinstalls the latest executable code from the master branch of the edx Github repository.
