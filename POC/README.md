![alt text](winarm.png)

- Ansible uses Protocol WinARM , with which we can make configuration on Windows VM.
- To activate WinArm use this command:
- winrm qc -force

## Ansible playbook for configuration of weight app on Windows VM

Operation that were taken:

- winrm enumerate winrm/config/listener
- winrm set winrm/config/service/auth '@{Basic="true"}'
- winrm set winrm/config/service '@{AllowUnencrypted="true"}' 
- compmgmt.msc - Shortcut for Computer Management Snippet
- netsh advfirewall firewall add rule name="WinRM 5985" dir=in action=allow protocol=TCP localport=5985
- netsh advfirewall firewall add rule name="WinRM 5985" dir=out action=allow protocol=TCP localport=5985
- winrs -r:http://machineip:5985/wsman -u:ansible -p:ansible_pass ipconfig/all
- ansible -i win_inventory all -m win_ping

- Ansible windows ping module with custom inventory file
- ssh-copy-id -i ~/.ssh/id_rsa ubuntu@13.90.33.21 -p 50001
- windows winrm settings required for winrm - https://stackoverflow.com/questions/39062954/unable-to-ping-my-windows-server-using-win-ping
- netsh advfirewall firewall add rule name="Weight-App 8080 IN" dir=in action=allow protocol=TCP localport=8080
- netsh advfirewall firewall add rule name="Weight-App 8080 OUT" dir=out action=allow protocol=TCP localport=8080


