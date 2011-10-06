# Configure ssh to not allow password based authentication so you don't get bruteforced
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
