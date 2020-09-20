# Multi-Cloud Application Deployment (GCP and AWS)

The project is utilises resources hosted in *two public Clouds* i.e; `Google Cloud Platform and Amazon Public Cloud`.The *application* is deployed in Kubernetes cluster managed by `Google Kubernetes Engine` provisioned and configured with the help of terraform. The *Database Server* is hosted in AWS Public cloud. The inter-connectivity between the public clouds is preformed using Site-To-Site VPN.


<p align="center">
  <img src="/screenshots/infra_flow.jpg" width="950" title="Infrastructure Flow">
  <br>
  <em>Fig 1.: Project Flow Diagram </em>
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
  <em>Fig 22.: SSH Key Generation </em>
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
  <em>Fig 23.: Create Key Pair </em>
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
aws ec2 describe-images --owners 309956199498 --query 'sort_by(Images, &CreationDate)[*].[CreationDate,Name,ImageId]'\
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
  <em>Fig 24.: Launching EC2 instance </em>
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

> Parameters:
>
> aws_bastion_connection_user           => Username for remote connection to bastion host
>
> aws_db_server_connection_user          => Username for remote connection to database server
>
> aws_connection_type                    => Connection type for remote connection to instances
>
> aws_mongo_db_root_username             => Database admin username
>
> aws_mongo_db_root_password             => Database admin user password
>
> aws_mongo_db_server_port               => Database server port
>
> aws_mongo_db_data_path                 => Database data directory path
>
> aws_mongo_db_application_username      => Database Application user
>
> aws_mongo_db_application_user_password => Database Application user password
>
> aws_mongo_db_application_db_name       => Application database name


## Module : gcp

