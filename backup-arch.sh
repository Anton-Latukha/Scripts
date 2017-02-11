#!/bin/dash

# Save list of installed packages
pacman -Qqe > pkglist-"$(date -I)".txt

# Save pacman database
tar --create --auto-compress --file pacman_database-"$(date -I)".tar.xz /var/lib/pacman/local/
