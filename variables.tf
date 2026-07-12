variable "github_token" {
  description = "GitHub personal access token with repo scope on target_repo and rust_companion_repo. Never committed — passed as TF_VAR_github_token."
  type        = string
  sensitive   = true
}

variable "target_repo" {
  description = "GitHub repository name (without org) to receive CI variables and the RUST_DEPLOY_KEY secret (e.g. 'stratum-proto')."
  type        = string
}

variable "rust_companion_repo" {
  description = "GitHub repository name (without org) to receive the SSH deploy key (e.g. 'stratum-proto-rust')."
  type        = string
}

variable "gar_location" {
  description = "Value for the GAR_LOCATION Actions variable."
  type        = string
}

variable "gar_project_id" {
  description = "Value for the GAR_PROJECT_ID Actions variable."
  type        = string
}

variable "gar_repository" {
  description = "Value for the GAR_REPOSITORY Actions variable."
  type        = string
}

variable "gar_package_index_url" {
  description = "Value for the GAR_PACKAGE_INDEX_URL Actions variable."
  type        = string
}

variable "wif_provider" {
  description = "Value for the WIF_PROVIDER Actions variable."
  type        = string
}

variable "wif_service_account" {
  description = "Value for the WIF_SERVICE_ACCOUNT Actions variable."
  type        = string
}

variable "github_org" {
  description = "GitHub organisation owning both target_repo and rust_companion_repo."
  type        = string
}

variable "environment" {
  description = "Deployment environment label (e.g. 'dev')."
  type        = string

  validation {
    condition     = contains(["dev", "stage", "main"], var.environment)
    error_message = "environment must be one of: dev, stage, main."
  }
}

variable "tags" {
  description = "Unused in the GitHub provider (no label support); reserved for interface consistency."
  type        = map(string)
  default     = {}
}
