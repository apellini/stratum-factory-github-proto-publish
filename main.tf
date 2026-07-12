# Generate an ed25519 SSH keypair for the Rust companion repo deploy key.
# Private key is sensitive and stored only in state + GitHub secret.
resource "tls_private_key" "rust_deploy" {
  algorithm = "ED25519"
}

# Write-access deploy key on stratum-proto-rust
resource "github_repository_deploy_key" "rust_deploy" {
  repository = var.rust_companion_repo
  title      = "stratum-proto publisher (${var.environment}) — managed by OpenTofu"
  key        = tls_private_key.rust_deploy.public_key_openssh
  read_only  = false
}

# Store the private key as RUST_DEPLOY_KEY secret in stratum-proto
resource "github_actions_secret" "rust_deploy_key" {
  repository      = var.target_repo
  secret_name     = "RUST_DEPLOY_KEY"
  value = tls_private_key.rust_deploy.private_key_openssh
}

# CI variables in stratum-proto — one per required Actions var
resource "github_actions_variable" "gar_location" {
  repository    = var.target_repo
  variable_name = "GAR_LOCATION"
  value         = var.gar_location
}

resource "github_actions_variable" "gar_project_id" {
  repository    = var.target_repo
  variable_name = "GAR_PROJECT_ID"
  value         = var.gar_project_id
}

resource "github_actions_variable" "gar_repository" {
  repository    = var.target_repo
  variable_name = "GAR_REPOSITORY"
  value         = var.gar_repository
}

resource "github_actions_variable" "gar_package_index_url" {
  repository    = var.target_repo
  variable_name = "GAR_PACKAGE_INDEX_URL"
  value         = var.gar_package_index_url
}

resource "github_actions_variable" "wif_provider" {
  repository    = var.target_repo
  variable_name = "WIF_PROVIDER"
  value         = var.wif_provider
}

resource "github_actions_variable" "wif_service_account" {
  repository    = var.target_repo
  variable_name = "WIF_SERVICE_ACCOUNT"
  value         = var.wif_service_account
}

resource "github_actions_variable" "rust_companion_repo" {
  repository    = var.target_repo
  variable_name = "RUST_COMPANION_REPO"
  value         = "${var.github_org}/${var.rust_companion_repo}"
}
