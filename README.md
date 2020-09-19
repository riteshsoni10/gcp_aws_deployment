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
  <img src="/screenshots/gcp_project_creation.png" width="950" title="GCP Project">
  <br>
  <em>Fig 7.: Project detais in GCP </em>
</p>


### Resource Manager API in `Google Cloud`

The resource manager api is to be enabled to create the resource in Google Cloud Platform.

1. Click on top left menu button and Select **Library** in **API and Services**

<p align="center">
  <img src="/screenshots/gcp_api_enable.png" width="950" title="GCP API Lbrary">
  <br>
  <em>Fig 8.: API Library </em>
</p>

2. Search for string "resource"
3. Enable **Cloud Resource Manager API**

<p align="center">
  <img src="/screenshots/gcp_enable_crm.png" width="950" title="GCP API Lbrary">
  <br>
  <em>Fig 8.: Cloud Resource API </em>
</p>


### Service Account in GCP

Creating a service account is similar to adding a member to your project, but the service account belongs to the applications rather than an individual end user. The project utilises the service account credentials to provision resources in the cloud platform.

1. Select **Service Accounts** from **IAM & Admin** in the Menu

<p align="center">
  <img src="/screenshots/gcp_sa.png" width="950" title="GCP Service Account">
  <br>
  <em>Fig 9.: Service Account </em>
</p>

2 Enter the service account details

<p align="center">
  <img src="/screenshots/gcp_sa_create.png" width="950" title="GCP Service Account Details">
  <br>
  <em>Fig 10.: Service Account Details </em>
</p>

3. Grant Privileges to the Service Account

<p align="center">
  <img src="/screenshots/gcp_sa_permissions.png" width="950" title="GCP Service Account Permissions">
  <br>
  <em>Fig 11.: Service Account Privileges </em>
</p>

4. Then, click on Continue
5. Click Create

**List Service Acounts**

<p align="center">
  <img src="/screenshots/gcp_sa_created.png" width="950" title="GCP Service Account ">
  <br>
  <em>Fig 11.: Service Account </em>
</p>

6. Create **New Access Key**

<p align="center">
  <img src="/screenshots/gcp_sa_key_generate.png" width="950" title="GCP Service Account Access Key">
  <br>
  <em>Fig 12.: Generate Service Account Access Key</em>
</p>

7. Select the **Key Type**  and click on **Create**

  The recommended key format is *JSON*. It will download the *service_account* access key, which will be used to provision resources in GCP provider in terraform.

<p align="center">
  <img src="/screenshots/gcp_sa_key_json.png" width="950" title="GCP Service Account">
  <br>
  <em>Fig 13.: Download Access Key </em>
</p>
  

**Initalising Terraform in workspace Directory**

```sh
terraform init 
```

<p align="center">
  <img src="/screenshots/terraform_initialise.png" width="950" title="Initialising Terraform">
  <br>
  <em>Fig 14.: Initialisng Terraform </em>
</p>


Each Task is distributed into `modules` and located in *automation_scripts/modules* directory i.e 
- AWS Infrastructure
- AWS Bastion Host
- Database Server in AWS
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
  <img src="/screenshots/vpc_network.png" width="950" title=" AWS VPC">
  <br>
  <em>Fig 15.: AWS VPC </em>
</p>


Terraform Validate to check for any syntax errors in Terraform Configuration file

```sh
terraform validate
```

<p align="center">
  <img src="/screenshots/terraform_validate.png" width="950" title="Syntax Validation">
  <br>
  <em>Fig 16.: Terraform Validate </em>
</p>




### AWS Public and Private Subnets

In public subnet, the instances launched can be accessed from outside the aws VPC network whereas, the instances launched in private subnet cannnot be accessed from outside vpc network. The project creates public and private subnets in each available availability zone. Instances launched in public subnets are defined to be assigned public IP automatically. 
The HCL code for priate subnets is shown below similiarly the public subnets can also be created.

```tf
## Private Subnets
resource "aws_subnet" "private_subnets" {
    count  = length(data.aws_availability_zones.available_zones.names)
    cidr_block  = cidrsubnet(var.vpc_cidr_block,8,"${10+count.index}")
    vpc_id      = aws_vpc.backend_network.id
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
  <em>Fig 17.: Plan: Public and Private Subnets </em>
</p>


## NAT Gateway and Internet Gateway

An `Internet Gateway` is a logical connection between an Amazon VPC and the Internet. It is not a physical device. Only one can be associated with each VPC. It does not limit the bandwidth of Internet connectivity. 

```tf
## Internet Gateway
resource "aws_internet_gateway" "application_igw" {
    vpc_id = aws_vpc.backend_network.id
    tags = {
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
  <img src="/screenshots/nat_gw.png" width="950" title="AWS NAT">
  <br>
  <em>Fig 18.: Plan: NAT Gateway </em>
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
  <em>Fig 19.: Plan: Route Tables </em>
</p>
