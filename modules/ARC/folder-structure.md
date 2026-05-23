```bash
terraform-hybrid-ci/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
│
├── modules/
│   ├── eks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── irsa-runner/
│   │   ├── main.tf
│   │   └── variables.tf
│   │
│   └── arc/
│       ├── main.tf
│       └── variables.tf
```
## How to use
```bash
terraform init
terraform apply
```

```bash
kubectl get pods -n arc-system
kubectl get pods -n arc-runners
```

## 🔹 GitHub Workflow Example
```yaml
jobs:
  test:
    runs-on: ubuntu-latest

  build:
    runs-on: [self-hosted, k8s-runners]
```

## 🧠 Pro Tips (Production)  
- Store GitHub token in **AWS Secrets Manager**
- Restrict IAM policy (avoid `*`)
- Use custom runner image
- Add cluster autoscaler  
