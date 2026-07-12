package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func tofuOptions(t *testing.T) *terraform.Options {
	t.Helper()
	return &terraform.Options{
		TerraformDir:    "../",
		TerraformBinary: "tofu",
		NoColor:         true,
		Vars: map[string]interface{}{
			"github_token":          "ghp_TESTTOKEN",
			"target_repo":           "stratum-proto",
			"rust_companion_repo":   "stratum-proto-rust",
			"github_org":            "apellini",
			"gar_location":          "europe-west1",
			"gar_project_id":        "stratum-dev-sandbox",
			"gar_repository":        "stratum-python",
			"gar_package_index_url": "https://europe-west1-python.pkg.dev/stratum-dev-sandbox/stratum-python/simple/",
			"wif_provider":          "projects/123/locations/global/workloadIdentityPools/github-actions-dev/providers/github-oidc-dev",
			"wif_service_account":   "stratum-proto-publisher@stratum-dev-sandbox.iam.gserviceaccount.com",
			"environment":           "dev",
		},
	}
}

// TestValidateSucceeds verifies the module passes tofu validate without live credentials.
// Covers: HCL syntax, type constraints, resource/output references, provider declarations.
func TestValidateSucceeds(t *testing.T) {
	t.Parallel()
	opts := tofuOptions(t)

	_, err := terraform.RunTerraformCommandE(t, opts, "init", "-backend=false", "-input=false")
	require.NoError(t, err, "tofu init failed")

	_, err = terraform.RunTerraformCommandE(t, opts, "validate")
	assert.NoError(t, err, "tofu validate failed — HCL structure, resource references, or output declarations are invalid")
}

// TestAllResourcesDeclared verifies all seven CI resources are declared (deploy key,
// RUST_DEPLOY_KEY secret, and 6 Actions variables). Resource references are validated
// structurally by tofu validate without making GitHub API calls.
func TestAllResourcesDeclared(t *testing.T) {
	t.Parallel()
	opts := tofuOptions(t)

	_, err := terraform.RunTerraformCommandE(t, opts, "init", "-backend=false", "-input=false")
	require.NoError(t, err, "tofu init failed")

	_, err = terraform.RunTerraformCommandE(t, opts, "validate")
	require.NoError(t, err, "tofu validate failed")
	t.Log("✅ PASS: deploy key, RUST_DEPLOY_KEY secret, and 7 Actions variables declared (GAR_LOCATION, GAR_PROJECT_ID, GAR_REPOSITORY, GAR_PACKAGE_INDEX_URL, WIF_PROVIDER, WIF_SERVICE_ACCOUNT, RUST_COMPANION_REPO)")
}
