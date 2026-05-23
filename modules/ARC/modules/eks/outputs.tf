output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "oidc_arn" {
  value = module.eks.oidc_provider_arn
}
