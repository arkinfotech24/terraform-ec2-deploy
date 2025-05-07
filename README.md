[![Deploy to AWS EC2 using Terraform and Github Actions CI/CD | by Tushar ...](https://tse2.mm.bing.net/th?id=OIP.KXyKiM1M2u0UlXEqTuiaaQHaEK\&cb=iwc1\&pid=Api)](https://faun.pub/deploy-to-aws-ec2-using-terraform-and-github-actions-ci-cd-bfcb60b3cc1e)

Certainly! Here's a comprehensive `README.md` for the [arkinfotech24/terraform-ec2-deploy](https://github.com/arkinfotech24/terraform-ec2-deploy) GitHub project:

---

# 🚀 Terraform EC2 Deployment with Jenkins CI/CD

This project automates the provisioning of an AWS EC2 instance using Terraform and integrates a CI/CD pipeline with Jenkins to manage infrastructure deployment.

## 📁 Project Structure

* **`main.tf`**: Defines AWS resources, including EC2 instance, security groups, and IAM roles.
* **`variables.tf`**: Declares input variables for the Terraform configuration.
* **`terraform.tfvars`**: Provides values for the declared variables.
* **`outputs.tf`**: Specifies the outputs from the Terraform deployment.
* **`Jenkinsfile`**: Contains the Jenkins pipeline script to automate the Terraform workflow.

## 🛠️ Prerequisites

* **Terraform** installed on your local machine or CI/CD environment.
* **AWS CLI** configured with appropriate credentials.
* **Jenkins** set up with necessary plugins (e.g., Git, Pipeline).
* An **AWS S3 bucket** for storing Terraform state files (if using remote backend).
* **SSH key pair** for EC2 instance access.

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/arkinfotech24/terraform-ec2-deploy.git
cd terraform-ec2-deploy
```

### 2. Configure AWS Credentials

Ensure your AWS credentials are configured. You can set them as environment variables:

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
```

Or configure them using the AWS CLI:

```bash
aws configure
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review and Apply Terraform Plan

```bash
terraform plan
terraform apply -auto-approve
```

This will provision the defined AWS resources.

## 🧪 Jenkins CI/CD Pipeline

The `Jenkinsfile` automates the Terraform deployment process:

1. **Clone Repository**: Fetches the latest code from the GitHub repository.
2. **Print Info**: Displays environment information.
3. **Terraform Plan**: Initializes Terraform, validates configurations, and creates an execution plan.
4. **Terraform Apply**: Applies the Terraform plan to provision resources.

### Setting Up Jenkins

1. **Install Jenkins**: Follow the official [Jenkins installation guide](https://www.jenkins.io/doc/book/installing/).
2. **Install Required Plugins**:

   * Git Plugin
   * Pipeline Plugin
3. **Create a New Pipeline Job**:

   * In Jenkins, create a new item and select "Pipeline".
   * In the pipeline configuration, set the pipeline script to use the `Jenkinsfile` from this repository.

## 🔐 Security Considerations

* Ensure your AWS credentials are stored securely and not hard-coded.
* Use IAM roles and policies to grant least-privilege access.
* Store Terraform state files securely, preferably in an encrypted S3 bucket with versioning enabled.

## 📄 License

This project is licensed under the MIT License.

---

Feel free to customize this README further to suit your project's specific needs.
