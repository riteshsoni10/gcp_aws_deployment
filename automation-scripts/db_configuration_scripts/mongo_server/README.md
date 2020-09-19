Role Name : mongo_server
=========

The role helps in installation and configuration of Mongo Database Server on Redhat Enterprise Linux 8.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

**mongo_repo_base_url:**

    Mongo Repository URL like  "https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.4/x86_64/"

**packages_name:** 

    List of packages to be installed in database server i.e ["mongodb-org","python3-pip"]

**mongo_db_root_username:**

    Database Admin Username i.e "root"

**mongo_db_root_password:**

    Database admin user password;
  
**mongo_db_root_user_roles:**

    Database admin user priviledges like "readWriteAnyDatabase,dbAdminAnyDatabase,clusterAdmin"
  
**mongo_db_server_port:**

    Database server port like "27017"

**mongo_db_data_path:**

    Datbase DB storage path like "/var/lib/mongo"

**mongo_db_bind_ip:**

    Database server bind ip like "0.0.0.0"
  
**mongo_db_conf_location:** 

    Database server default configuration file => "/etc/mongod.conf"

**application_username:**

    Database application user name like  "appuser"

**application_user_password:**

    Database application user password.
  
**application_user_priviledges:**

    Application user priviledges such as "readWrite"

**application_db_name:**

    Application Database Name 
