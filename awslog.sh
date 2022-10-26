# Install, configure and enable CloudWatch Logs on the AMI
## Create a CloudWatch config file
echo Creating a config file for the CloudWatch agent
mkdir -p /var/awslogs/etc/
cat <<'EOF' > /var/awslogs/etc/awslogs.conf
[general]
state_file = /var/awslogs/state/agent-state

[/var/lib/docker/containers/*/*-json.log]
file = /var/lib/docker/containers/*/*-json.log
log_stream_name = {hostname}
log_group_name = {instance_id}-{hostname}-{ip_address}
datetime_format = %Y-%m-%d %H:%M:%S
initial_position = start_of_file
EOF
## Install the CloudWatch logs agent
echo Installing the CloudWatch logs agent
curl https://github.com/svakhovskyi/awslogs-agent/blob/44ddde171af22373406fb1c3110a9d160eaf27b8/awslogs-agent-setup.py -O &&
sudo python ./awslogs-agent-setup.py -n -r eu-central-1 -c /var/awslogs/etc/awslogs.conf &&
sudo service awslogs start &&
sudo chkconfig awslog on
