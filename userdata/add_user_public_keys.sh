#! /bin/bash

# paul thomas
echo "${ssh_key}" >> /home/ec2-user/.ssh/authorized_keys

chown ec2-user: /home/ec2-user/.ssh/authorized_keys
chmod 0600 /home/ec2-user/.ssh/authorized_keys

