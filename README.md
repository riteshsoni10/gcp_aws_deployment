# Multi-Cloud Application Deployment (GCP and AWS)

The project is utilises resources hosted in *two public Clouds* i.e; `Google Cloud Platform and Amazon Public Cloud`.The *application* is deployed in Kubernetes cluster managed by `Google Kubernetes Engine` provisioned and configured with the help of terraform. The *Database Server* is hosted in AWS Public cloud. The inter-connectivity between the public clouds is preformed using `Site-To-Site VPN`.

**Project Flow**

<p align="center">
  <img src="/screenshots/infra_flow.png" width="950" title="Project Architecture">
  <br>
  <em>Fig 1.: Project Architecture </em>
</p>


## Scope of Project

1. Configure custom Virtual Private Networks in Google and AWS Cloud
2. Configure Site-to-Site VPN between both the clouds
3. Create Kubernetes Cluster using GKE
4. Create Database EC2 Instance in Amazon Private Network
5. Create Bastion Host in AWS Cloud
6. Configure Database Server
7. Deploy Application on Kubernetes Cluster

 	
## Pre-Requisites

**Packages**
- awscli 
- terraform

**Accounts**
- AWS Cloud admin user account
- Google Cloud admin user account

> Recommended Controller Node Operating System: 
>
> Redhat Enterprise Linux 8


### IAM User in AWS Account

1. Login using root account into AWS Console
2. Go to IAM Service

<p align="center">
  <img src="/screenshots/iam_user_creation.png" width="950" title="IAM Service">
  <br>
  <em>Fig 2.: IAM User creation </em>
</p>

3. Click on User
4. Add User
5. Enable Access type `Programmatic Access`

<p align="center">
  <img src="/screenshots/iam_user_details.png" width="950" title="Add User">
  <br>
  <em>Fig 3.: Add new User </em>
</p>

6. Attach Policies to the account
	For now, you can click on `Attach existing policies directly` and attach `Administrator Access`

<p align="center">
  <img src="/screenshots/iam_user_policy_attach.png" width="950" title="User Policies">
  <br>
  <em>Fig 4.: IAM User policies </em>
</p>

7. Copy Access and Secret Key Credentials


### Configure the AWS Profile in Controller Node

The best and secure way to configure AWS Secret and Access Key is by using aws cli on the controller node

```sh
aws configure --profile <profile_name>
```

<p align="center">
  <img src="/screenshots/aws_profile_creation.png" width="950" title="AWS Profile">
  <br>
  <em>Fig 5.: Configure AWS Profile </em>
</p>


### Google Cloud Project

The project resource is created manually since creation of `Organisation` in `Google Cloud Platform` is out of the scope of project. The project resource can only be created using resource manager API when the Organisation is already defined in the GCP.

1. Login into GCP using Admin credentials 
2. Click on **Select a Project**

<p align="center">
  <img src="/screenshots/gcp_project_create.png" width="950" title="GCP Project">
  <br>
  <em>Fig 6.: Create Project in GCP </em>
</p>

3. Enter the project details

<p align="center">
  <img src="/screenshots/gcp_project_creation.png" width="550" title="GCP Project">
  <br>
  <em>Fig 7.: Project detais in GCP </em>
</p>


### Resource Manager API in `Google Cloud`

The resource manager api is to be enabled to create the resource in Google Cloud Platform.

1. Click on top left menu button and Select **Library** in **API and Services**

<p align="center">
  <img src="/screenshots/gcp_api_enable.png" width="450" title="GCP API Lbrary">
  <br>
  <em>Fig 8.: API Library </em>
</p>

2. Search for string "resource"
3. Enable **Cloud Resource Manager API**

<p align="center">
  <img src="/screenshots/gcp_enable_crm.png" width="950" title="GCP API Lbrary">
  <br>
  <em>Fig 9.: Cloud Resource API </em>
</p>


### Service Account in GCP

Creating a service account is similar to adding a member to your project, but the service account belongs to the applications rather than an individual end user. The project utilises the service account credentials to provision resources in the cloud platform.

1. Select **Service Accounts** from **IAM & Admin** in the Menu

<p align="center">
  <img src="/screenshots/gcp_sa.png" width="950" title="GCP Service Account">
  <br>
  <em>Fig 10.: Service Account </em>
</p>

2 Enter the service account details

<p align="center">
  <img src="/screenshots/gcp_sa_create.png" width="950" title="GCP Service Account Details">
  <br>
  <em>Fig 11.: Service Account Details </em>
</p>

3. Grant Privileges to the Service Account

<p align="center">
  <img src="/screenshots/gcp_sa_permissions.png" width="950" title="GCP Service Account Permissions">
  <br>
  <em>Fig 12.: Service Account Privileges </em>
</p>

4. Then, click on Continue
5. Click Create

**List Service Acounts**

<p align="center">
  <img src="/screenshots/gcp_sa_created.png" width="950" title="GCP Service Account ">
  <br>
  <em>Fig 13.: Service Account </em>
</p>

6. Create **New Access Key**

<p align="center">
  <img src="/screenshots/gcp_sa_key_generate.png" width="950" title="GCP Service Account Access Key">
  <br>
  <em>Fig 14.: Generate Service Account Access Key</em>
</p>

7. Select the **Key Type**  and click on **Create**

  The recommended key format is *JSON*. It will download the *service_account* access key, which will be used to provision resources in GCP provider in terraform.

<p align="center">
  <img src="/screenshots/gcp_sa_key_json.png" width="950" title="GCP Service Account">
  <br>
  <em>Fig 15.: Download Access Key </em>
</p>
  

**Initalising Terraform in workspace Directory**

```sh
terraform init 
```

<p align="center">
  <img src="/screenshots/terraform_initialise.png" width="950" title="Initialising Terraform">
  <br>
  <em>Fig 16.: Initialisng Terraform </em>
</p>


Each Task is distributed into `modules` and located in *automation_scripts/modules* directory i.e 
- AWS Infrastructure
- Database Server in AWS
- AWS Bastion Host
- Database Server Configuration
- Kubernetes Cluster in GCP using GKE
- Application Deployment
- Site-to-Site VPN


The `static variables` used in parent module are passed using `terraform.tfvars` file.

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:
 - Environment variables
 - The terraform.tfvars file, if present.
 - The terraform.tfvars.json file, if present.
 - Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
 - Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)


## Module : aws_network

The module provisions the custom `virtual private network` along with public and private subnets in Amazon Public Cloud. The module creates multiple resources suchh as elastic IP, nat gateway, internet gateway, subnets and vpc in AWS Cloud. The HCL code to invoke module is as follows:

```tf
module "aws_cloud" {
    source = "./modules/aws_network"
    vpc_cidr_block = var.aws_vpc_cidr_block
}
```

> Parameters
>
> vpc_cidr_block     => Variable defined inside the module for VPC CIDR Block
>
> aws_vpc_cidr_block => Variable defined at parent level to provide the input to module


### Amazon VPC

The Virtual Private Network in which the database server and the Bastion Host will be launched is created with the  help of followig HCL code

```tf
## Backend Database Network
resource "aws_vpc" "backend_network" {
    cidr_block = var.vpc_cidr_block
    tags       = {
            Name = "Backend-Network"
    }
}
```

> Parameters
>
> cidr_block => VPC CIDR block

<p align="center">
  <img src="/screenshots/vpc_network.png" width="750" title=" AWS VPC">
  <br>
  <em>Fig 17.: AWS VPC </em>
</p>


Terraform Validate to check for any syntax errors in Terraform Configuration file

```sh
terraform validate
```

<p align="center">
  <img src="/screenshots/terraform_validate.png" width="950" title="Syntax Validation">
  <br>
  <em>Fig 18.: Terraform Validate </em>
</p>


### AWS Public and Private Subnets

In public subnet, the instances launched can be accessed from outside the aws VPC network whereas, the instances launched in private subnet cannnot be accessed from outside vpc network. The project creates public and private subnets in each available availability zone. Instances launched in public subnets are defined to be assigned public IP automatically. 
The HCL code for priate subnets is shown below similiarly the public subnets can also be created.

```tf
## Private Subnets
resource "aws_subnet" "private_subnets" {
    count              = length(data.aws_availability_zones.available_zones.names)
    cidr_block         = cidrsubnet(var.vpc_cidr_block,8,"${10+count.index}")
    vpc_id             = aws_vpc.backend_network.id
    availability_zone  = element(data.aws_availability_zones.available_zones.names,count.index)
    tags  = {
        Name  = "Private Subnet - ${element(data.aws_availability_zones.available_zones.names,count.index)}"
    }

    depends_on = [
        aws_vpc.backend_network
    ]
}
```

> Paramters
>
> length()     => calculate the number of available Availability Zones
>
> cidrsubnet() => Calculates the Subnet CIDRs dynamically in VPC CIDR block
>
> element()    => element retrieves a single element from a list i.e; element(list, index)


**Function: cidrsubnet**

Terraform provides handy function called `cidrsubnet` which is able to calculate subnet address within the given IP network address space.

cidrsubnet(iprange, newbits, netnum) where:

    iprange = CIDR of the virtual network
        172.10.1.0/23
    newbits = the difference between subnet mask and network mask
        *27 - 23 = 4*
    netnum = practically the subnet index
        0 = 172.10.0.0/27
        1 = 172.10.0.32/27
        2 = 172.10.0.64/27
        3 = 172.10.0.96/27


<p align="center">
  <img src="/screenshots/public_private_subnets.png" width="950" title="AWS Subnets">
  <br>
  <em>Fig 19.: Plan: Public and Private Subnets </em>
</p>


## NAT Gateway and Internet Gateway

An `Internet Gateway` is a logical connection between an Amazon VPC and the Internet. It is not a physical device. Only one can be associated with each VPC. It does not limit the bandwidth of Internet connectivity. 

```tf
## Internet Gateway
resource "aws_internet_gateway" "application_igw" {
    vpc_id = aws_vpc.backend_network.id
    tags   = {
        Name = "Backend-IGW"
    }
    depends_on = [
        aws_vpc.backend_network
    ]
}
```

Instances in a private subnet that want to access the Internet can have their Internet-bound traffic forwarded to the `NAT gateway` via a Route Table configuration. The NAT gateway will then make the request to the Internet (since it is in a Public Subnet) and the response will be forwarded back to the private instance.

```tf
## Nat Gateway
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_public_ip.id
    subnet_id     = aws_subnet.public_subnets.0.id

    depends_on = [
        aws_eip.nat_public_ip,
        aws_subnet.public_subnets,
    ]
}
```

> Parameters
>
> allocation_id => The Id of the Elastic IP resource
>
> subnet_id     => Public Subnet ID 


<p align="center">
  <img src="/screenshots/nat_gw.png" width="750" title="AWS NAT">
  <br>
  <em>Fig 20.: Plan: NAT Gateway </em>
</p>


### Public and Private Route Table

The private route table is associated with the private subnets which enables the private subnets to interact with the internet. The public subnets are associated with the public subnets that enables the inbound and outbound traffic from the subnet.

```tf
# Public Route Table
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.backend_network.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.application_igw.id
    }
    tags = {
        Name = "public_route_table"
    }

    depends_on = [
        aws_internet_gateway.application_igw,
        aws_vpc.backend_network,
    ]
}

## Private Route Table
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.backend_network.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gw.id
    }
    tags = {
        Name = "private_route_table"
    }
    depends_on = [
        aws_vpc.backend_network,
        aws_nat_gateway.nat_gw
    ]
}
```

<p align="center">
  <img src="/screenshots/public_private_route_table.png" width="950" title="AWS Route Tables">
  <br>
  <em>Fig 21.: Plan: Route Tables </em>
</p>


## Module : db_server

The module launches the Database Server instance in Private Subnet. The HCL Code for the module invocation is as follows :

```tf
module "database_server" {
   source             = "./modules/db_server"
   vpc_id             = module.aws_cloud.vpc_id
   vpc_cidr_block     = var.aws_vpc_cidr_block
   gcp_network_cidrs  = [var.gcp_subnet_cidr,var.gcp_pods_network_cidr,var.gcp_services_network_cidr]
   ami_id             = var.aws_db_ami_id
   instance_type      = var.aws_db_instance_type
   db_port            = var.aws_mongo_db_server_port
   private_subnet_id  = module.aws_cloud.private_subnets[0]
   key_name           = var.aws_db_key_name
}
```

> Paramaters:
>
> aws_vpc_cidr_block => VPC CIDR Block to enable SSH from instances in network
>
> gcp_network_cidrs  => Allow Database Server port to be accessed by GCP cloud resources


### Create Key Pair

The Public-private Key is generated using `tls_private_key` resource and uploaded to the AWS using `aws_key_pair`. The SSH login Key is stored in `automation_scripts` directory.

<p align="center">
  <img src="/screenshots/db_instance_key_tls.png" width="950" title="SSH-Keygen SSH Key Pair">
  <br>
  <em>Fig 22.: Plan: SSH Key Generation </em>
</p>


HCL Code to create Instance Key-Pair
```tf
#Creating AWS Key Pair for EC2 Instance Login
resource "aws_key_pair" "upload_db_instance_key" {
        key_name   = var.key_name
        public_key = tls_private_key.db_instance_key.public_key_openssh
        depends_on = [
                tls_private_key.db_instance_key
        ]
}
```
 
<p align="center">
  <img src="/screenshots/db_instance_key.png" width="950" title="Create Key Pair">
  <br>
  <em>Fig 23.: Plan: Create Key Pair </em>
</p>

 
 ### Create Security Groups
 
The SSH access and Database Server Port Access is allowed to database server instance from VPC Network and GCP Cloud Network respectively.
 
 ```tf
resource "aws_security_group" "db_server_security_group" {
        name = "allow_ssh_mysql_access"
        description = "Mysql Server Access from GCP and SSH from VPC Network"
        vpc_id     = var.vpc_id
        ingress {
                protocol    = "tcp"
                from_port   = 22
                to_port     = 22
                cidr_blocks = [var.vpc_cidr_block]
                description = "SSH Access"
        }
        ingress {
                protocol    = "tcp"
                from_port   = var.db_port
                to_port     =   var.db_port
                cidr_blocks = var.gcp_network_cidrs
                description = "Mysql Server Access from GCP Cloud "
        }
        egress {
                protocol    = -1
                from_port   = 0
                to_port     = 0
                cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
                Name = "Database SG"
        }
}
```


### Launch Database Server instance

We are going to launch the Database Server EC2 instance with the Key and security group generated above. For now, we will be using the RedHat Enterprise Linux 8.2 i.e `ami-08369715d30b3f58f`. The Official Redhat Enterprise Linux AMI Ids can be found out using the aws cli as below

```sh
aws ec2 describe-images --owners 309956199498 \
--query 'sort_by(Images, &CreationDate)[*].[CreationDate,Name,ImageId]' \
--filters "Name=name,Values=RHEL-8*" --region ap-southeast-1 --output table --profile aws_terraform_user
```

The HCL Code for EC2 instance resource is as shown below:

```tf
#Creating EC2 instance for Database Server
resource "aws_instance" "db_server" {
        ami                    = var.ami_id
        instance_type          = var.instance_type
        subnet_id              = var.private_subnet_id
        vpc_security_group_ids = [aws_security_group.db_server_security_group.id]
        key_name               = aws_key_pair.upload_db_instance_key.key_name
        tags = {
                Name = "db-server"
        }
        depends_on = [
                aws_security_group.db_server_security_group,
                aws_key_pair.upload_db_instance_key,
        ]
}
```
 
<p align="center">
  <img src="/screenshots/db_instance.png" width="950" title="Create EC2 instance">
  <br>
  <em>Fig 24.: Plan: Launching EC2 instance </em>
</p>


## Module : aws_bastion_host

The module creates the ec2 instance as Bastion host to interact with the database server launched in the private subnet. The resources are created similiar to the database server.
The HCL code to call module is as follows:

```tf
module "aws_bastion_host" {
  source                             = "./modules/aws_bastion_host"
  vpc_id                             = module.aws_cloud.vpc_id
  bastion_ami_id                     = var.aws_bastion_ami_id
  bastion_instance_type              = var.aws_bastion_instance_type
  public_subnet_id                   = module.aws_cloud.public_subnets[0]
  key_name                           = var.aws_bastion_key_name
}
```


## Module : db_configure

The module uploads the mongo database configuration playbook to the bastion host and configures the mongo database on EC2 instance launched in the private subnet. 

```tf
module "db_server_configure" {
  source                             = "./modules/db_configure"
  connection_user                    = var.aws_bastion_connection_user
  db_connection_user                 = var.aws_db_server_connection_user
  connection_type                    = var.aws_connection_type
  bastion_host_public_ip             = module.aws_bastion_host.public_ip
  bastion_host_key_name              = module.aws_bastion_host.key_name
  db_server_private_ip               = module.database_server.db_private_ip
  db_instance_key_name               = module.database_server.key_name
  mongo_db_root_username             = var.aws_mongo_db_root_username
  mongo_db_root_password             = var.aws_mongo_db_root_password
  mongo_db_server_port               = var.aws_mongo_db_server_port
  mongo_db_data_path                 = var.aws_mongo_db_data_path
  mongo_db_application_username      = var.aws_mongo_db_application_username
  mongo_db_application_user_password = var.aws_mongo_db_application_user_password
  mongo_db_application_db_name       = var.aws_mongo_db_application_db_name
}
```


### Upload Playbook and DB instance Key

The playbook is uploaded from the controller node to the Bastion Host and the ansible-playbook is remotely executed on the bastion host to configure the Mongo Database server on database instance launched in private subnet. The `file` provisioner is used to upload the playbook and the database instance private key to the bastion host

```tf
resource "null_resource" "upload_db_playbook"{
        provisioner "file" {
                source = "db_configuration_scripts"
                destination = "/tmp/"
                connection {
                        type        = var.connection_type
                        user        = var.connection_user
                        private_key = file(var.bastion_host_key_name)
                        host        = var.bastion_host_public_ip
                }
        }
}
```

### Playbook execution for Database Confirguration

The playbook is exeuted in the bastion host to install and configure the database server on EC2 instance launched in private subnet.

```tf
resource  "null_resource" "mongo_db_configure"{
    depends_on = [
        null_resource.upload_db_server_key
    ]
    connection{
        type = var.connection_type
        host = var.bastion_host_public_ip
        user  = var.connection_user
        private_key = file(var.bastion_host_key_name)
    }
    provisioner remote-exec {
        inline =[
            "sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y",
            "sudo dnf install ansible -y",
            "sudo ansible-playbook -u ${var.db_connection_user} -i ${var.db_server_private_ip}, --private-key /tmp/${var.db_instance_key_name} /tmp/db_configuration_scripts/db_server.yml  -e mongo_db_root_username=${var.mongo_db_root_username} -e mongo_db_root_password=${var.mongo_db_root_password} -e mongo_db_server_port=${var.mongo_db_server_port} -e mongo_db_data_path=${var.mongo_db_data_path} -e application_username=${var.mongo_db_application_username} -e application_user_password=${var.mongo_db_application_user_password} -e application_db_name=${var.mongo_db_application_db_name}  --ssh-extra-args=\"-o stricthostkeychecking=no\""
        ]
    }
}
```


## Module : gcp

The module is responsible to configure custom network, subnets, vpn tunnels and provision `Google Kubernetes Engine` Cluster in `Google Cloud Platform`.

```tf
module "gcp_cloud" {
    source                 = "./modules/gcp"
    subnet_cidr            = var.gcp_subnet_cidr
    pods_network_cidr      = var.gcp_pods_network_cidr
    services_network_cidr  = var.gcp_services_network_cidr
    network_name           = var.gcp_network_name
    cluster_name           = var.gcp_cluster_name
    cluster_zone           = var.gcp_cluster_zone
    load_balancing_state   = var.gcp_load_balancing_state
    node_count             = var.gcp_node_count
    node_disk_size         = var.gcp_node_disk_size
    node_preemptible_state = var.gcp_node_preemptible_state
    node_machine_type      = var.gcp_node_machine_type
    pod_scaling_state      = var.gcp_pod_scaling_state
    node_pool_name         = var.gcp_node_pool_name
}
```


### Enable Google Cloud APIs

The Google Cloud APIs for Compute Engine and Kubernetes Engine are required to luanch the respective resources. The HCL is code as follows:

```tf
resource "google_project_service" "gke_api_enable" {
    service             = "container.googleapis.com"
    disable_on_destroy  = false
}
resource "google_project_service" "compute_engine_api_enable" {
    service             = "compute.googleapis.com"
    disable_on_destroy  = false
```

<p align="center">
  <img src="/screenshots/gcp_compute_api_enable.png" width="950" title="Google CLoud API Enable">
  <br>
  <em>Fig 25.: Google Cloud API Enable</em>
</p>


## Google Cloud Network and Subnets

The custom network resource in Google Cloud is created. In GCP, the zones and subnets are defined differently as compared to the AWS Cloud. In AWS Cloud a subnet can resides only in one Availability zone whereas in GCP, the subnets can span in multiple_zones.

HCL code to create Virtual network in GCP
```tf
## VPC Network
resource "google_compute_network" "app_network" {
    name                    = "${var.network_name}-vpc"
    auto_create_subnetworks = false
}
```

<p align="center">
  <img src="/screenshots/gcp_network.png" width="950" title="Google Cloud Network">
  <br>
  <em>Fig 26.: Google Cloud Network</em>
</p>


HCL code to create custom subnets in Network
```tf
## Create Subnets
resource "google_compute_subnetwork" "app_subnet" {
    name          = "${var.network_name}-subnet"
    ip_cidr_range = var.subnet_cidr
    network       = "${var.network_name}-vpc"
    depends_on    = [
        google_compute_network.app_network
    ]
}
```

<p align="center">
  <img src="/screenshots/gcp_subnet.png" width="950" title="Google Cloud Subnet">
  <br>
  <em>Fig 27.: Google Cloud Subnets</em>
</p>


### Firewall Rules

The firewall rule to allow ssh into the instances launched in the GCP subnet.

```tf
## Firewall Rule for SSH
resource "google_compute_firewall" "ssh_access" {
    name         = "ssh-firewall"
    network      = google_compute_network.app_network.name
    allow {
        protocol = "tcp"
        ports    = ["22"]
    }
    source_ranges = ["0.0.0.0/0"]
    depends_on    = [
        google_compute_network.app_network
    ]
}
```


### Google Kubernetes Engine Cluster

Google Kubernetes Engine (GKE) is a management and orchestration system for Docker container  and container clusters that run within Google's public cloud services. Google Kubernetes Engine is based on Kubernetes, Google's open source container management system. 

There are two types of GKE clusters in Google Cloud based on networking i.e;
- Legacy Routing Clusters
- VPC-native Clusters

In `Legacy clusters`, the kubernetes Pods and services are in abstraction from outside network whereas, in `VPC-native` clusters the pods and services networks works as secondary network ranges to the VPC or Google Cloud network. The VPC cluster enables the pods to connect with  outside network without any extra configurations in cluster.

The GKE cluster can be of two types based on location i.e;
- Zonal Clusters
- Regional Clusters

A `zonal cluster`, the cluster master along with the worker nodes are only present in a single zone. In contrast, in a `regional cluster`, cluster master nodes are present in multiple zones in the region. For that reason, regional clusters should be preferred.

The project provisions `Regional VPC-native GKE cluster`. In the current cluster, the password based authentication is disabled, only token based authentication is supported. In GKE cluster, worker nodes are launched inside the node_pools.  HCL code for GKE cluster provisioning is as follows: 

```tf
resource "google_container_cluster" "kubernetes_cluster" {
    name = var.cluster_name
    location = var.cluster_zone
    master_auth {
        username  = ""
        password  = ""
        client_certificate_config {
            issue_client_certificate = false
        }
    }
    ip_allocation_policy {
        cluster_ipv4_cidr_block = var.pods_network_cidr
        services_ipv4_cidr_block = var.services_network_cidr
    }
    remove_default_node_pool = true
    initial_node_count = var.node_count
    network = google_compute_network.app_network.name
    subnetwork = google_compute_subnetwork.app_subnet.name
    addons_config {
        http_load_balancing {
            disabled = var.load_balancing_state
        }
        horizontal_pod_autoscaling {
            disabled = var.pod_scaling_state
        }
    }
}
```

<p align="center">
  <img src="/screenshots/gke_cluster.png" width="950" title="Google Cloud GKE Cluster">
  <br>
  <em>Fig 28.: Google Kubernetes Cluster</em>
</p>


### Google Kubernetes Engine Cluster Node Pool

The worker nodes are launched in google kubernetes engine node pools. HCL Code is as following:

```tf
resource "google_container_node_pool" "kubernetes_node_pool"{
    name = var.node_pool_name
    location = var.cluster_zone
    cluster = google_container_cluster.kubernetes_cluster.name
    node_count = var.node_count
    node_config {
        preemptible = var.node_preemptible_state
        metadata = {
            disable-legacy-endpoints = "true"
        }
        disk_size_gb = var.node_disk_size
        machine_type = var.node_machine_type
        oauth_scopes = [
           "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
        ]
    }
}
```

<p align="center">
  <img src="/screenshots/gke_node_pool.png" width="950" title="Google Cloud GKE Node Pool">
  <br>
  <em>Fig 29.: Google Kubernetes Cluster Node Pool</em>
</p>


## Module : vpn

The module enables the private connectivity between the resources provisioned in Google and Amazon public clouds using Site-to-Site VPN.

```tf
module "gcp_aws_vpn" {
    source = "./modules/vpn"
    aws_vpc_id = module.aws_cloud.vpc_id
    aws_route_table_ids = [module.aws_cloud.public_route_table_id, module.aws_cloud.private_route_table_id]
    gcp_network_id = module.gcp_cloud.network_id
}
```

### AWS VPN Resources

A Site-to-Site VPN connection offers two VPN tunnels between a virtual private gateway or a transit gateway on the AWS side, and a customer gateway (which represents a VPN device) on the remote (Google Cloud) side. For Site-to-Site VPN Connection we require virtual private gateway, customer gateway and at last vpn tunnel resource on AWS side.  

<p align="center">
  <img src="/screenshots/aws_vpn.png" width="450" title="AWS VPN Overview">
  <br>
  <em>Fig 30.: AWS VPN Overview</em>
</p>


**Virtual Private Gateway**

A virtual private gateway is the VPN concentrator on the Amazon side of the Site-to-Site VPN connection. In this project a virtual private gateway is created and attached to the databased VPC from which the Site-to-Site VPN connection is to be established.

**Route Propagation**

The traffic from GCP networks is configured in route table to pass via virtual private gateway

```sh
## Route Propogation
resource "aws_vpn_gateway_route_propagation" "public_private" {
    count = length(var.aws_route_table_ids)
    route_table_id = element(var.aws_route_table_ids,count.index)
    vpn_gateway_id = aws_vpn_gateway.virtual_gw.id
    depends_on = [
        aws_vpn_gateway.virtual_gw,
    ]
}
```

**Customer Gateway**

A customer gateway is a resource that is created in AWS which represents the customer gateway device in your other network. When a customer gateway is created, the information about the device at other end of network is passed to AWS; i.e Public IP of GCP Cloud Gateway

```tf
## Customer Gateway with Public IP of GCP Cloud Gateway
resource "aws_customer_gateway" "google" {
    bgp_asn = 65000
    ip_address = google_compute_address.vpn_ip.address
    type = "ipsec.1"
    tags = {
        Name = "Google Cloud Customer Gateway"
    }
    depends_on = [
        google_compute_address.vpn_ip,
    ]
}
```

**VPN Tunnel**

The VPN tunnel is created with the combination of all the above resources i.e virtual private gateway and customer gateway.

```tf
## AWS VPN Tunnel
resource "aws_vpn_connection" "aws_to_gcp" {
    vpn_gateway_id = aws_vpn_gateway.virtual_gw.id
    customer_gateway_id = aws_customer_gateway.google.id
    type = "ipsec.1"
    static_routes_only = false
    tags = {
        Name = " AWS-To-Google VPN"
    }
    depends_on = [
        aws_vpn_gateway.virtual_gw,
        aws_customer_gateway.google,
    ]
}
```

<p align="center">
  <img src="/screenshots/aws_gcp_vpn.png" width="950" title="AWS VPN">
  <br>
  <em>Fig 31.: AWS VPN </em>
</p>


### Google Cloud VPN Resources

The static Public IP is required which will be passed to AWS network for configuration of customer gateway. 


**VPN Gateway**

The Google Cloud VPN Gateway works in a similiar way as AWS Virtual Private Gateway

```tf
## VPN Gateway
resource "google_compute_vpn_gateway" "gcp_aws_gateway" {
    name = "vpn-gateway"
    network = var.gcp_network_id
}
```

Some firewall forwarding rules must be attached with the VPN gateway such as 
- Protocol: ESP
- Protocol: UDP, Port: 500,4500

**Google Compute Router**

`Cloud Router` is a fully distributed and managed Google Cloud service that programs custom dynamic routes and scales with your network traffic. Cloud Router works with both legacy networks and Virtual Private Cloud (VPC) networks. Cloud Router isn't a connectivity option, but a service that works over Cloud VPN or Cloud Interconnect connections to `provide dynamic routing` by using the Border Gateway Protocol (BGP) for VPC networks.

```tf
resource "google_compute_router" "gcp_vpn_router" {
    name = "gcp-vpn-router"
    network = var.gcp_network_id
    bgp{
        asn = aws_customer_gateway.google.bgp_asn
    }
    depends_on = [
        aws_customer_gateway.google,
    ]
}
```

<p align="center">
  <img src="/screenshots/gcp_vpn_router.png" width="950" title="GCP VPN">
  <br>
  <em>Fig 32.: GCP Compute Router </em>
</p>


**VPN Tunnel**

The VPN tunnel resource helps in establishing the connection from GCP to AWS privately.

```tf
## VPN tunnel
resource "google_compute_vpn_tunnel"  "gcp_aws_vpn" {
    name               = "gcp-aws-vpn-tunnel-1"
    peer_ip            = aws_vpn_connection.aws_to_gcp.tunnel1_address
    shared_secret      = aws_vpn_connection.aws_to_gcp.tunnel1_preshared_key
    ike_version        = 1
    target_vpn_gateway = google_compute_vpn_gateway.gcp_aws_gateway.id
    router             = google_compute_router.gcp_vpn_router.id
    depends_on         = [
        aws_vpn_connection.aws_to_gcp,
        google_compute_vpn_gateway.gcp_aws_gateway,
        google_compute_router.gcp_vpn_router
    ]
}
```


## Module : kubernetes

The module is responsible for application deployment on top of kubernetes cluster over Google Cloud.

```tf
module "application_deployment" {
    source              = "./modules/kubernetes"
    aws_vpc_cidr        = var.aws_vpc_cidr_block
    mongo_db_host       = module.database_server.db_private_ip
    mongo_db_port       = var.aws_mongo_db_server_port
    app_image_name      = var.app_docker_image_name
    app_container_port  = var.app_container_port
    app_port            = var.app_expose_port
    db_app_username     = var.aws_mongo_db_application_username
    db_app_password     = var.aws_mongo_db_application_user_password
    db_database_name    = var.aws_mongo_db_application_db_name
}
```


### Kubernetes Secret Resource

The Database application user credentials are stored in kubernetes secret resource to prevent passing credentils in plain text to deployment resource. HCL Code to create secret resource :

```tf
resource "kubernetes_secret" "db_secret" {
        metadata{
                name = "mongo-db-secret"
        }
        data = {
                username      = var.db_app_username
                password      = var.db_app_password
                database      = var.db_database_name
        }
}
```


### Kubernetes Deployment and Service Resource

The `deployment kubernetes resource` is created to implement fault tolerance behaviour while running pods i.e, to restart the application pods in case anyone of them fails. The `service kubernetes resource` creates load balancer resource to serve traffic on application pods based on pod labels.

<p align="center">
  <img src="/screenshots/application_service.png" width="950" title="Application Service">
  <br>
  <em>Fig 33.: Kubernetes Service Resource </em>
</p>


# Usage Instructions

You should have configured IAM profile in the controller node by following instructions.

1. Clone this repository
2. Change the working directory to `automation-scripts`
3. Run `terraform init`
4. Then, `terraform plan`, to see the list of resources that will be created

<p align="center">
  <img src="/screenshots/total_resources.png" width="950" title="Teraform Resource Count">
  <br>
  <em>Fig 34.: Terraform Total Number of Resources </em>
</p>

5. Then, `terraform apply -auto-approve`

<p align="center">
  <img src="/screenshots/gcp_resource_output.png" width="950" title="Teraform Output">
  <br>
  <em>Fig 35.: Terraform Output </em>
</p>


In case, you would like to deploy applications using `kubectl` cli on GKE cluster; so `gcloud SDK` is necessary for kubectl configuration. For example:

```sh
gcloud container clusters get-credentials kubernetes-cluster --region asia-southeast1 --project nodejs-frontend-app
```

The above command will configure the kubectl cli and you can now connect to the GKE cluster from the local node


When you are done playing
```sh
terraform destroy -auto-approve
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region_name | Default Region Name for AWS Infrastructure | string | `` | yes |
| aws_user_profile | IAM Credentials of AWS Account with required priviledges | string | `` | yes |
| aws_vpc_cidr_block | CIDR block for AWS VPC Network | string | `` | yes |
| aws_db_ami_id | AMI Id for launching  Database Server EC2 Instance | string | `` | yes |
| aws_db_instance_type | EC2 Instance Type for Database Server | string | `` | yes |
| aws_db_key_name | Key name for Database Server EC2 instannce | string | `` | yes |
| aws_bastion_ami_id | AMI Id for launching Bastion Host EC2 Instance | string | `` | yes |
| aws_bastion_instance_type | EC2 Instance Type for Bastion Host in AWS | string | `` | yes |
| aws_bastion_key_name | Key name for Bastion Host EC2 instannce | string | `` | yes |
| aws_bastion_connection_user | Username for SSH connection to Bastion Host EC2 instance | string | `ec2-user` | yes |
| aws_db_server_connection_user | Username for SSH connection to Database Server EC2 instance | string | `ec2-user` | yes |
| aws_connection_type | Type of connection for remote-exec provisioner like (ssh,winrm) | string | `ssh` | no |
| app_expose_port | Port Numer to Expose the Application in Kubernetes Service | number | `` | yes |
| app_container_port | Port Number on which Application is exposed in Image | number | `` | yes |
| app_docker_image_name | Docker Image for the applcation Pods | string | `string` | yes |
| aws_mongo_db_root_username | Database Server Admin Username | string | `` | yes |
| aws_mongo_db_root_password | Database server Admin User Password  | string | `` | yes |
| aws_mongo_db_server_port | Database Server Port Number | string | `` | yes |
| aws_mongo_db_data_path | Data Directory of mongo Database Server | string | `` | yes |
| aws_mongo_db_application_username | Database Application Username" | string | `` | yes |
| aws_mongo_db_application_user_password | Database Application User Password | string | `` | yes |
| aws_mongo_db_application_db_name | Database Name | string | `` | yes |
| gcp_credentials_file_name | GCP Credentials File name" | string | `` | yes |
| gcp_region_name | Region Name to launch GCP Resources | string | `` | yes |
| gcp_project_id | Unique Project Id for Application Deployment | string | `` | yes |
| gcp_network_name | GCP VPC Network Name | string | `` | yes |
| gcp_subnet_cidr | Application Subnet CIDR/ Prefix | string | `` | yes |
| gcp_pods_network_cidr | Application Pods Subnet CIDR/ Prefix | string | `` | yes |
| gcp_services_network_cidr | Application Pods Services Subnet CIDR/ Prefix | string | `` | yes |
| gcp_cluster_name | Kubernetes Cluster Name | string | `` | yes |
| gcp_cluster_zone | Cluster Zone name such as asiasoutheast-1 | string | `` | yes |
| gcp_load_balancing_state | Boolean value to enable/disable HTTP Load Balanacing | bool | `` | yes |
| gcp_pod_scaling_state | Enable/Disable Horizotal Scaling of Pods | bool | `` | yes |
| gcp_node_count | Number of nodes in cluster | number | `` | yes |
| gcp_node_preemptible_state | Enable/Disable Nodes Premptible state | bool | `` | yes |
| gcp_node_machine_type | GKE Worker Nodes Instance Machine Type| string | `` | yes |
| gcp_node_disk_size | GKE Worker Nodes Disk Size in GB | string | `` | yes |
| gcp_node_pool_name | Node Pool Cluster Name | string | `` | yes |


## Outputs

| Name | Description |
|------|-------------|
| gcp_gke_endpoint | GKE Cluster Endpoint |
| aws_bastion_public_ip | Bastion Host Public IP |
| aws_NAT_public_ip | Public IP of AWS NAT Gateway |
| aws_public_subnet_cidrs |  List of Public Subnet CIDR  blocks |
| aws_private_subnet_cidrs | List of Private Subnet CIDR  blocks  |
| aws_public_subnet_ids | List of Public Subnet Ids |
| aws_private_subnet_ids | List of Private Subnet Ids |
| database_server_private_ip | Private IPs of Database Server EC instance |
| database_server_key_name | Key Pair Name used during launching Database Server EC2 instance |
| application_endpoint | Public IP of Load Balancer for Accessing Application |


## Screenshots

**1. Google Cloud Network**

<p align="center">
  <img src="/screenshots/gcp_console_vpc.png" width="950" title="GCP VPC">
  <br>
  <em>Fig 36.: GCP Network </em>
</p>

**2. Kubernetes Cluster**

<p align="center">
  <img src="/screenshots/gke_console_cluster.png" width="950" title="GKE Cluster">
  <br>
  <em>Fig 37.: GKE Cluster </em>
</p>

**3. Kubernetes Worker Nodes**

<p align="center">
  <img src="/screenshots/gcp_console_worker_nodes.png" width="950" title="Worker Nodes">
  <br>
  <em>Fig 38.: GKE Cluster Worker Nodes </em>
</p>

**4. Google Cloud VPN**

<p align="center">
  <img src="/screenshots/gcp_console_vpn.png" width="950" title="VPN">
  <br>
  <em>Fig 39.: GCP VPN </em>
</p>

**5.  AWS VPC Network**

<p align="center">
  <img src="/screenshots/aws_console_vpc.png" width="950" title="AWS VPC">
  <br>
  <em>Fig 40.: AWS VPC </em>
</p>

**6. AWS Subnets** 

<p align="center">
  <img src="/screenshots/aws_console_subnets.png" width="950" title="AWS Subnets">
  <br>
  <em>Fig 41.: AWS Subnets </em>
</p>

**7. AWS VPN**

<p align="center">
  <img src="/screenshots/aws_console_vpn.png" width="950" title="AWS VPN">
  <br>
  <em>Fig 42.: AWS VPN </em>
</p>

**8. Bastion and DB Server Instances**

<p align="center">
  <img src="/screenshots/aws_console_instances.png" width="950" title="AWS Instances">
  <br>
  <em>Fig 43.: AWS Instances </em>
</p>


