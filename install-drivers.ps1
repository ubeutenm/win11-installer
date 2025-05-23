# This script installs drivers from a specified backup directory using pnputil.
pnputil /add-driver "$PSScriptRoot\M93p\*.inf" /subdirs /install /reboot
