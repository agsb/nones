# WSL tips

    Configure Windows 11 WSL2 for internal networking

## Mirror network

Edit  \Users\<YourUserName>\.wslconfig.

Add or modify the following lines

        [wsl2]
        networkingMode=mirrored

Restart wsl

## In WSL

In /etc/wsl.conf

        [boot]
        systemd=true

## In powershell: 
    
### icmp

        netsh advfirewall firewall add rule name="Virtual Machine Monitoring (ICMPv4-In)" dir=in action=allow protocol=icmpv4:8,any enable=yes profile=any

### sshd

        netsh advfirewall firewall add rule name="SSH Access" dir=in action=allow protocol=TCP localport=2200

### rsynd

        netsh advfirewall firewall add rule name="RSYNC Access" dir=in action=allow protocol=TCP localport=8730

### restart wsl

        wsl --shutdown

