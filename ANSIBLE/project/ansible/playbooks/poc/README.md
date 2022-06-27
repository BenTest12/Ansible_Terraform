![alt text](https://cdn.comparitech.com/wp-content/uploads/2021/03/WinRM-Guide.jpg)

- Ansible uses the WINRM to communicate with windows machines , with which we can make configuration on Windows VM's.
- To configure WINRM please follow this guide.

## Ansible playbook for configuration of weight app on Windows VM

Operation that were taken:

- winrm qc -force - Configures winrm HTTP listener without human interaction
- winrm enumerate winrm/config/listener - Shows active listeners (if any)
- winrm set winrm/config/service/auth '@{Basic="true"}' - Enables Basic authentication (User and password)
- winrm set winrm/config/service '@{AllowUnencrypted="true"}' - Enables authentication as plain text
- compmgmt.msc - Shortcut for Computer Management Snippet - Used to create and assign users accounts to groups , etc...
- netsh advfirewall firewall add rule name="WinRM 5985" dir=in action=allow protocol=TCP localport=5985 - Command to add an input connection firewall rule
- netsh advfirewall firewall add rule name="WinRM 5985" dir=out action=allow protocol=TCP localport=5985 - Command to add an output firewall rule
- winrs -r:http://machineip:5985/wsman -u:ansible -p:ansible_pass ipconfig/all - Test Windows Remote shell locally 
- ansible -i win_inventory all -m win_ping - Run this command if the winrs command returnes the desired output which is ipconfig/all

- windows winrm settings required for winrm - https://stackoverflow.com/questions/39062954/unable-to-ping-my-windows-server-using-win-ping
- netsh advfirewall firewall add rule name="Weight-App 8080 IN" dir=in action=allow protocol=TCP localport=8080
- netsh advfirewall firewall add rule name="Weight-App 8080 OUT" dir=out action=allow protocol=TCP localport=8080


