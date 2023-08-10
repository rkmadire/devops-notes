#!/bin/bash
# modify password for existing user 
# Replace 'ubuntu' with the username of the user you want to set the password for
username="ubuntu"

# Replace 'your_new_password' with the desired password
new_password="mypassword"

# Create a temporary file to store the username and password
temp_file=$(mktemp)

# Write the username and password in the temporary file
echo "$username:$new_password" > "$temp_file"

# Use chpasswd to set the password for the user
sudo chpasswd < "$temp_file"

# Remove the temporary file
rm "$temp_file"

# Optionally, you can verify if the password change was successful
if [ $? -eq 0 ]; then
  echo "Password set successfully for user: $username"
else
  echo "Failed to set the password for user: $username"
fi

# to make PasswordAuthentication no to yes
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

# restart service of ssh
sudo service ssh restart
