
netsh advfirewall firewall add rule name="Virtual Machine Monitoring (ICMPv4-In)" dir=in action=allow protocol=icmpv4:8,any enable=yes profile=any
  
netsh advfirewall firewall add rule name="SSH Access" dir=in action=allow protocol=TCP localport=2200
   
netsh advfirewall firewall add rule name="RSYNC Access" dir=in action=allow protocol=TCP localport=8730

