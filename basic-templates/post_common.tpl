# Configure ssh to not allow password based authentication so you don't get bruteforced
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
# Up the logging a bit so that key fingerprints are logged as well, why not.
sed -i 's/#LogLevel INFO/LogLevel VERBOSE/g' /etc/ssh/sshd_config

# rsyslog
echo "*.* @@logger.library.ualberta.ca:514" >> /etc/rsyslog.conf

# ntp
sed -i 's/server 0.rhel.pool.ntp.org/server time.srv.ualberta.ca/g' /etc/ntp.conf
sed -i 's/server 1.rhel.pool.ntp.org/server time2.srv.ualberta.ca/g' /etc/ntp.conf
sed -i 's/server 2.rhel.pool.ntp.org//g' /etc/ntp.conf

# root mail
sed -i 's/#root:		marc/root:		rootmail@logger.library.ualberta.ca/g' /etc/aliases
newaliases

# authorized_keys
mkdir /root/.ssh
chmod 700 /root/.ssh
cat > /root/.ssh/authorized_keys << EOAK
ssh-dss AAAAB3NzaC1kc3MAAACBAO4FgMUJDg7zsgw7vR/QmqYJLdyq8hzZvfota/76Gj/wGZ12ElXCU1vTEamYu71c/FNXMwxEjznV/BxNZl6jPcp5+PYtNJ00VYtyU3D0qUEsb9hn9SxNuhpGz5kM2aP6qo7n7BPmz+XAD2JkzzG2N8b8zp+yEaMT2uqvRGxoFiRvAAAAFQDNk8ydy9itCg6+ArKDEOCbIu/y8QAAAIBBYgf5/NU8PqjfgmTX1bAOnGqIyDU7Llvj/NJNMofnUNNLLhKynJjXZYRO6cvF6Tdu4j8yxb+cxrZEW6LjuPuaN5vPxIwCDTGRv54HnFClcztsWbG7RaH6Mnj84nts8yPGACNWG8dMCwCRaoaHE4kABzcWYGouGr/TGsgaJARGJgAAAIEAgJiJcPXrDX1LQM7vHrTDaWbw9Tl1GFmWgVmrG3fh/4VpgAOJeu/csG9hF9ZJnaAmNWvMn89R/t4h+bM4lqCa/zJ13hStJE+mFcnwSJu8RmJk2j2fGxGRYSvZgQwNpoyDY569YIPYZ4JFXfsM0s8DhgwwaWjD6Az6Kd8ZNNsoDCk= curtis@its-unicode
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBWcq6oKVb7OXV1JVgGF1oOsyixfC0t+PoENmC+pIcRrCBqfYUriXZxsFC57558Xg0fD+1PRZ8CNZplUtMqG6WILCvxvOUiWa7+YfmIl+s1jC6H4b+xE00NlcNBvirzey5vHvmosG7KWYWLib2TVw0xq5hDeTsI0QPhCZIWROu3qQ== rsa-key-20091119
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIB3vnQdVPdpOuUJcsb30q+U8GckXZxf9714SEgC0axzOB/jQ+UhL+G7B9NtdvYmR6bZPscxhJxz2H1FSAhcFmCHWj4QP412FZ8Ec9KPndAijEmree8+NzLPU8I25d4F64q6DVUV2OiH0r0XpgLta0OixgTK0mjsYWdvf0t044AVTQ== rsa-key-20100831
EOAK
chmod 600 /root/.ssh/authorized_keys


