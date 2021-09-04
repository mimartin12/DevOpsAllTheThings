# DevOps All The Things

## About <a name = "about"></a>

Just a repo to showcase and test various DevOps things and tools.

Technology used:
- Kubernetes
- Docker
- Terraform
- K3d
- GitHub Actions
- CLI tooling (YQ)

---

This repository currently holds Kubernetes, Docker, and Terraform deployments. 

### Dockerfile

The `Dockerfile` builds a container that runs the Litecoin daemon in a container.

### Kubernetes 

The three Kubernetes manifest deploys out a StatefulSet running the container that was built from the `Dockerfile`.

### Terraform

Inside the `tf-iam` folder is a Terraform module that is invoked by the `main.tf` file. Passing in some variables to customize the module.

## CI <a name = "ci"></a>

Two Github actions jobs exist around this project. 

`conatiner-ci-cd.yml` contains two stages.

- The build stage is responsible for building, scanning, and pushing the container to a public repository. 
- The deploy stage spins up Kubernetes cluster using K3d and deploys the kubernetes manifests in this repo to the cluster. At the end of the job, there is some `echo` commands that dumps out information around the deployment.

    > *I ended up using `YQ` to do some text manipulation to update the `image:` value with the newly tagged image that was built in the previous job.*

`terraform-ci.yml` contains a single stage. 

- It runs a `terraform validate` against the terraform in this repo. If that passes, it will run a step that formats the terraform code and creates a PR to resolve any formatting issues. This keeps the terraform code in this repo in a clean state.



## Documentation <a name = "docs"></a>

Various documentation was used in this project as a source to check for best practices and processes.

- Terraform
  - [IAM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)

- Kubernetes
  - [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

- Docker
  - [DockerFiles](https://docs.docker.com/engine/reference/builder/)

- K3D
  - [GitHub Action](https://github.com/marketplace/actions/setup-k3d-k3s)