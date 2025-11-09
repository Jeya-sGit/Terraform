# 🌱 Terraform Practice – Importing Existing AWS Infrastructure

## 📘 Objective

This folder marks the **first step** in my Terraform learning journey.
The goal is to **import existing AWS infrastructure** (an already running EC2 instance) into Terraform, generate the corresponding state files, and understand how Terraform tracks and manages infrastructure **without modifying** any existing setup.

---

## 🏗️ Overview

This folder and branch(feature/FirstScript) focus **only on importing existing AWS resources**.
No new infrastructure is created or destroyed.
The intention is to **practice** and **understand** how Terraform identifies, maps, and manages already existing resources using its internal state mechanism.

---

## ⚙️ Step-by-Step Practice

### **1️⃣ Initialize Terraform**

terraform init

**Purpose:**
Initializes the working directory and downloads required provider plugins (like AWS).
This sets up the `.terraform` directory and prepares the environment to run Terraform commands.

**What It Does:**

* Installs provider plugins (e.g., AWS).
* Configures backend for storing state.
* Creates important files such as:

  * `.terraform/`
  * `.terraform.lock.hcl`

✅ **Run this command** when:

* You start a new Terraform project.
* You add or modify providers.
* You switch branches or clone a repo.

---

### **2️⃣ Plan Configuration (Dry Run)**


terraform plan -generate-config-out=generated_existing_resources.tf


**Purpose:**
Creates an execution plan and optionally **generates Terraform configuration** for detected infrastructure.

**What It Does:**

* Shows what Terraform will do if configurations are applied.
* Validates provider connection and configuration.
* The `-generate-config-out` flag helps **auto-generate Terraform code** for existing resources (helpful after import).

---

### **3️⃣ Import Existing AWS Instance**

terraform import aws_instance.example <instance-id>


**Purpose:**
Imports an existing EC2 instance (by Instance ID) into Terraform’s state, letting Terraform start managing it.

**Example:**


terraform import aws_instance.example i-0ab12cde3f4g5h678


**Explanation:**

* `aws_instance` → Terraform resource type.
* `example` → Local resource name used in `.tf` file.
* `i-0bd37dac6c6b8i987` → Actual AWS instance ID.

**Result:**
Terraform updates the `terraform.tfstate` file to map this instance.
Now Terraform *knows* about the existing instance but won’t recreate or destroy it.

---

## 📂 Key Terraform Files Explained

### 🧩 `terraform.tfstate`

* Stores the **current state** of managed infrastructure.
* Maps Terraform resources to actual AWS resources.
* Acts as the **source of truth** for Terraform.
* Automatically updated after any import or apply operation.

⚠️ **Note:** Never edit manually. Keep it versioned securely (S3 backend is recommended in real setups).

---

### 🔒 `terraform.tfstate.lock.info`

* A **temporary lock file** created during Terraform operations (like `plan` or `apply`).
* Prevents multiple Terraform processes from running simultaneously (avoids state corruption).
* Automatically removed after the command completes.

If a lock remains due to crash/interruption:

terraform force-unlock <LOCK_ID>


---

### 📦 `terraform.lock.hcl`

* Locks provider versions used in this project.
* Ensures **consistent and repeatable runs** across machines/environments.
* Created during `terraform init`.

**Example content:**

provider "registry.terraform.io/hashicorp/aws" {
  version     = "5.64.0"
  constraints = ">= 3.0.0"
  hashes = ["h1:..."]
}


✅ Should be committed to source control.
❌ Should not be manually edited.

---

## ⚙️ Typical Terraform Workflow

| Step | Command                                                      | Description                                                |
| ---- | ------------------------------------------------------------ | ---------------------------------------------------------- |
| 1️⃣  | `terraform init`                                             | Initialize working directory and download provider plugins |
| 2️⃣  | `terraform import aws_instance.example <instance-id>`        | Import existing AWS resource into Terraform                |
| 3️⃣  | `terraform plan -generate-config-out=generated_resources.tf` | Generate Terraform config for imported infra               |
| 4️⃣  | `terraform plan`                                             | Review what Terraform will do before applying              |
| 5️⃣  | `terraform apply`                                            | Apply changes (if any) to real infrastructure              |

---

## ✅ Outcome

* Successfully imported an existing AWS EC2 instance into Terraform.
* Generated and understood Terraform’s key state and lock files.
* Verified how Terraform **tracks**, **locks**, and **represents** infrastructure.

This phase concludes the **Terraform import and state understanding** practice.
No infrastructure was modified — only imported and observed.

---

## 🧠 Key Learnings

* Terraform can **import and manage existing infrastructure** using `terraform import`.
* The **state file (`terraform.tfstate`)** acts as Terraform’s memory of real-world resources.
* **Locking (`terraform.tfstate.lock.info`)** ensures state consistency during concurrent operations.
* **Provider version locking (`terraform.lock.hcl`)** guarantees repeatable builds.
* The **plan command** helps preview and validate changes safely.

---

## 📁 Project Folder Summary

| File                          | Description                                                        | Persistent       |
| ----------------------------- | ------------------------------------------------------------------ | ---------------- |
| `main.tf`                     | Terraform configuration defining resource (`aws_instance.example`) | ✅                |
| `terraform.lock.hcl`          | Locks provider versions for consistent runs                        | ✅                |
| `terraform.tfstate`           | Maps real AWS infrastructure to Terraform resources                | ✅                |
| `terraform.tfstate.lock.info` | Temporary state lock file during Terraform runs                    | ❌ (auto-deleted) |
| `generated_resources.tf`      | Auto-generated config for imported resources                       | ✅ (optional)     |

---

## 🏁 Conclusion

This **Terraform Practice ** provided hands-on understanding of:

* Initializing a Terraform workspace.
* Importing and managing existing AWS resources.
* Understanding Terraform’s internal files (`.tfstate`, `.lock.hcl`, `.lock.info`).

It serves as the **foundation** for more advanced Terraform practices like:

* Creating new infrastructure.
* Managing remote state (S3 + DynamoDB).
* Implementing workspaces and modules.
* CICD integration for IaC automation.

---
