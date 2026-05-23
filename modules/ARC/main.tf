module "eks" {
  source = "./modules/eks"

  project         = var.project
  env             = var.env
  vpc_id          = var.vpc_id
  private_subnets = var.private_subnets
}

module "irsa_runner" {
  source = "./modules/irsa-runner"

  project        = var.project
  env            = var.env
  oidc_url       = module.eks.oidc_url
  oidc_arn       = module.eks.oidc_arn
}

module "arc" {
  source = "./modules/arc"

  github_org   = var.github_org
  github_repo  = var.github_repo
  github_token = var.github_token

  runner_role_arn = module.irsa_runner.role_arn
}
