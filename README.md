# Domain sudo user authenticating with the GUI
Meant for domain bound linux user machines. Tested on Ubuntu 16.04  

Issue: Domain user cannot authenticate on a domain bound computer using the gui but has sudo access and can authenticate in the terminal

Fix: This modified file has extra rules allowing the user to authenticate using the gui

# Modify polkit rules
1. sudo su
2. vi  /var/lib/polkit-1/localauthority/10-vendor.d/com.ubuntu.desktop.pkla  
3. Copy and paste the pkla file or create your own rules

# Creating Additional Rules
1. Check /var/log/auth.log to get action ID of actions that are being denied
2. Create rule
3. Add it to the end of /var/lib/polkit-1/localauthority/10-vendor.d/com.ubuntu.desktop.pkla


[DESCRIPTION OF RULE]  
Identity=unix-group:admin;unix-group:sudo  
Action=ID_HERE  
ResultActive=yes  
