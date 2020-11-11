#!/bin/bash
sed -i 's/\(^ONBOOT=\).*/\1yes/'  /etc/sysconfig/network-scripts/ifcfg-enp0s3
