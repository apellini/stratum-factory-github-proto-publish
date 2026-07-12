output "deploy_key_id" {
  description = "GitHub deploy key ID on stratum-proto-rust. Record this for runbook reference."
  value       = github_repository_deploy_key.rust_deploy.id
}
