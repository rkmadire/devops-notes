Ansible patch management
-------------------------
1. patch management it is a process of locating secrity flaws through out the organization and fixing them applying updates to servers, computers, softwares, and other technology systems
2. patch management is important it will help maintain network security and lower cyber risk by preparing vulnerabilities 

Why to do patch
-----------------
1. prevention of ransomeware
2. complience
3. Enhanced functionality and performance
4. Identification of obeselete software 

process of patching sysytems
-----------------------------
1. first check and create an inventory of which systems need to what to do patch 
2. setup which one require immediate patching 
3. we will patch the the system protect from potential cyber-attack
4. track the patching strategy by reporting progress 
5. system admins and developers must and should keep their systems up to date and apply all security patches 

Different ways of patching
----------------------------
1. patch all the os packages to the latest versions 
2. apply all security patches 
3. apply all bug fixes 


Best practices for patch 
-----------------------------
1. Determine the patchin priority based one the value and your company and the risk of breach 
2. using automated patch management we able to find out risk and apply patches 
3. use reports to track patch management strategy and encourage improvements in key metrics 
4. install critical updates as soon as posible to keep servers  from secure 
5. establish clear patch workflow to ensure that sysems are patches regular based and that emergency patches are applied as soon as posible 


#Practicals 
------------
##step1: setup ansible cluster
	
		 ansible all -m ping

## vim patch.yaml

		---
		- name: " This playbook is to apply patches to linux servers"
		  hosts: node1,node2
		  serial: 2
		  tasks:
		  - name: install httpd
		    yum:
		     name: httpd
		     state: latest
		    delegate_to: node2
		  - name: "Check whether application and database are running"
		    script: /home/ansible/dev/appcheck.sh
		    args:
		      executable: /bin/bash
		    ignore_errors: true
		    register: application_process_check
		  - name: "Will check and start patching on linux servers"
		    fail: msg='{{ inventory_hostname }} have running Application. Please stop application and then proceed with patch.'
		    when: application_process_check.stdout == "process is running"
		  - name: "Applying patches to the server"
		    yum: name=kernel state=latest
		    when: application_process_check.stdout == "Process is not running.\r\n" and ansible_distribution == "CentOS" or ansible_distribution == "RedHat"
		    register: patch_update
		  - name: "Check if reboot required"
		    shell: KERNEL_NEW=$(rpm -q --last kernel |head -1 | awk '{print $1}'|sed 's/kernel-//'); KERNEL_NOW=$(uname -r); if [[ $KERNEL_NEW != $KERNEL_NOW ]]; then echo "reboot needed"; else echo "reboot not needed"; fi
		    ignore_errors: true
		    register: reboot_status
		  - name: "This play is to restart the system using above status check"
		    command: shutdown -r +1 "Rebooting System After Patching"
		    async: 0
		    poll: 0
		    when: reboot_status.stdout == "reboot needed"
		    register: reboot_started
		    ignore_errors: true

		  - name: "This play will wait for 1 minutes for system to come up"
		    pause: minutes=1
		    
		    # Now we will run a local 'ansible -m ping' on this host until it returns.
		    # This works with the existing ansible hosts inventory and so any custom ansible_ssh_hosts definitions are being used
		  - name: check the system status
		    local_action: shell ansible -u ansible -m ping {{ inventory_hostname }}
		    register: resultThe complete playbook, including all tasks, is shown above.
		    until: result.rc == 0
		    retries: 30
		    delay: 10

		    # And finally, execute 'uptime' when the host is back.
		  - name: check the client uptime
		    shell: uptime


#BreakDown above yaml file
--------------------------
###Task 1 — Installing httpd
	
		- name: install httpd
	  	  yum:
	   		name: httpd
	   		state: latest
	  	  delegate_to: node2


Task 2 — Check whether application and database are running

		- name: "Check whether application and database are running"
		    script: /home/ansible/ansible_demo/appcheck.sh
		    args:
		      executable: /bin/bash
		    ignore_errors: true
		    register: application_process_check


	Note:Here there is a small script to check the application and database below are the contents of it.

		#!/bin/bash
		# to check application status
		ps cax | egrep "apache|http|pmon|oracle"| grep -v grep >/dev/null
		if [ $? -eq 0 ]
		 then
		 echo "Process is running."
		 else
		 echo "Process is not running."
		fi


##Task 3 — Check whether the application is stopped and start the patching
	
		- name: "Will check and start patching on linux servers"
		    fail: msg='{{ inventory_hostname }} have running Application. Please stop application and then proceed with patch.'
		    when: application_process_check.stdout == "process is running"


##Task 4 — Applying patches to the server.

		- name: "Applying patches to the server"
		    yum: name=kernel state=latest
		    when: application_process_check.stdout == "Process is not running.\r\n" and ansible_distribution == "CentOS" or ansible_distribution == "RedHat"
		    register: patch_update


##Task 5 — Check if reboot required


		- name: "Check if reboot required"
		    shell: KERNEL_NEW=$(rpm -q --last kernel |head -1 | awk '{print $1}'|sed 's/kernel-//'); KERNEL_NOW=$(uname -r); if [[ $KERNEL_NEW != $KERNEL_NOW ]]; then echo "reboot needed"; else echo "reboot not needed"; fi
		    ignore_errors: true
		    register: reboot_status


##Task 6 — According to above status reboot will be started

		- name: "This play is to restart the system using above status check"
		    command: shutdown -r +1 "Rebooting System After Patching"
		    async: 0
		    poll: 0
		    when: reboot_status.stdout == "reboot needed"
		    register: reboot_started
		    ignore_errors: true


##Task 7 — This play will wait for 1 minutes for system to come up

		- name: "This play will wait for 1 minutes for system to come up"
		    pause: minutes=1


##Task 8 — Check the system status

		- name: check the system status
		    local_action: shell ansible -u ansible -m ping {{ inventory_hostname }}
		    register: result
		    until: result.rc == 0
		    retries: 30
		    delay: 10


##Task 9 — Check the client uptime

		- name: check the client uptime
		    shell: uptime


