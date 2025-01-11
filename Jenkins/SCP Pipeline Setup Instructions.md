SCP Pipeline Setup Instructions

## SCP Command Example
```bash
scp sourcefile username@private_ip:destination_path

# Example for transferring WAR files
scp /var/lib/jenkins/workspace/declarative-pipeline/webapp/target/webapp.war ubuntu@QA-server_private_ip:/var/lib/tomcat9/webapps/testapp.war
scp /var/lib/jenkins/workspace/declarative-pipeline/webapp/target/webapp.war ubuntu@QA-server_private_ip:/var/lib/tomcat9/webapps/testapp.war
```

---

## Step 1: QA Server Setup
1. **Connect to QA Server:**
   ```bash
   ssh ubuntu@QA-server_private_ip
   ```
2. **Modify `sshd_config` file:**
   - Change `PasswordAuthentication no` to `PasswordAuthentication yes`.
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```
3. **Restart the SSH service:**
   ```bash
   sudo systemctl restart sshd
   ```
4. **Set a password for the `ubuntu` user:**
   ```bash
   sudo passwd ubuntu
   ```
5. **Change permissions for the `tomcat9` directory:**
   ```bash
   sudo chmod o+x -R /var/lib/tomcat9
   ```

---

## Step 2: Production Server Setup
1. **Connect to Production Server:**
   ```bash
   ssh ubuntu@prod_server_private_ip
   ```
2. **Modify `sshd_config` file:**
   - Change `PasswordAuthentication no` to `PasswordAuthentication yes`.
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```
3. **Restart the SSH service:**
   ```bash
   sudo systemctl restart sshd
   ```
4. **Set a password for the `ubuntu` user:**
   ```bash
   sudo passwd ubuntu
   ```
5. **Change permissions for the `tomcat9` directory:**
   ```bash
   sudo chmod o+x -R /var/lib/tomcat9
   ```

---

## Step 3: Jenkins Server Configuration
1. **Connect to Jenkins Server:**
   ```bash
   ssh ubuntu@jenkins_server_private_ip
   ```
2. **Switch to Jenkins user:**
   ```bash
   sudo su - jenkins
   ```
3. **Generate SSH Key Pair:**
   ```bash
   ssh-keygen -t rsa -b 4096
   ```
4. **Copy the Public Key to QA and Production Servers:**
   ```bash
   ssh-copy-id ubuntu@QA-server_private_ip
   ssh-copy-id ubuntu@prod_server_private_ip
   ```
5. **Verify Passwordless Authentication:**
   - Ensure Jenkins can connect to QA and Production servers without a password.
   ```bash
   ssh ubuntu@QA-server_private_ip
   ssh ubuntu@prod_server_private_ip
   ```

---

## Step 4: Declarative Pipeline Project
1. **Create a New Declarative Pipeline Project:**
   - In Jenkins, create a new pipeline job.

2. **Define Stages:**
   - **Continuous Deployment (QA Server):**
     ```groovy
     sh '''scp /var/lib/jenkins/workspace/declarative-pipeline/webapp/target/webapp.war ubuntu@QA-server_private_ip:/var/lib/tomcat9/webapps/test.war'''
     ```
   - **Continuous Delivery (Production Server):**
     ```groovy
     sh '''scp /var/lib/jenkins/workspace/declarative-pipeline/webapp/target/webapp.war ubuntu@prod-server_private_ip:/var/lib/tomcat9/webapps/prod.war'''
     ```

3. **Save and Apply Configuration:**
   - Click "Apply" and "Save" in Jenkins.

4. **Build the Pipeline Job:**
   - Trigger a build and monitor the logs for any issues.

---

## Notes
- Ensure proper permissions for Jenkins to access the required directories on QA and Production servers.
- Validate the deployment by accessing the web applications on respective servers.
- Regularly review logs for potential issues with SCP or directory permissions.
