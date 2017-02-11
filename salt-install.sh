#!/bin/bash

sudo -s

pacman -Sy salt-raet --noconfirm

systemctl enable salt-master
systemctl start salt-master



systemctl enable salt-minion
systemctl start salt-minion
