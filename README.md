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
  
