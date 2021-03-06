# 1-org

The purpose of this step is to setup top level shared folders, monitoring & networking projects, org level logging and set baseline security settings through organizational policy.

## Prerequisites

1. 0-bootstrap executed successfully.
2. Cloud Identity / Gsuite group for security admins
3. Membership in the security admins group for user running terraform

## Usage

**Disclaimer:** This step enables [Data Access logs](https://cloud.google.com/logging/docs/audit#data-access) for all services in your organization.
Enabling Data Access logs might result in your project being charged for the additional logs usage.
You can choose not to enable the Data Access logs by setting variable `data_access_logs_enabled` to false.

### Setup to run via Cloud Build
1. Clone repo `gcloud source repos clone gcp-org --project=YOUR_CLOUD_BUILD_PROJECT_ID` (this is from terraform output from the previous section, 0-bootstrap)
1. Navigate into the repo `cd gcp-org` and change to a non prod branch `git checkout -b plan`
1. Copy contents of foundation to new repo `cp -R ../terraform-example-foundation/1-org/* .` (modify accordingly based on your current directory)
1. Copy cloud build configuration files for terraform `cp ../terraform-example-foundation/build/cloudbuild-tf-* . ` (modify accordingly based on your current directory)
1. Rename terraform.example.tfvars to terraform.tfvars and update the file with values from your environment and bootstrap (you can re-run `terraform output` in the 0-bootstrap directory to find these values). Make sure that `default_region` is set to a valid [BigQuery dataset region](https://cloud.google.com/bigquery/docs/locations).
1. Rename backend.tf.example backend.tf and update with your bucket from bootstrap.
1. Commit changes with `git add .` and `git commit -m 'Your message'`
1. Push your non prod branch to trigger a plan `git push --set-upstream origin plan`
    1. Review the plan output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to prod branch with `git checkout -b prod` and `git push origin prod`
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID


### Run terraform locally
1. Change into 1-org/envs/shared/ folder
1. Rename terraform.example.tfvars to terraform.tfvars and update the file with values from your environment and bootstrap.
1. Rename backend.tf.example backend.tf and update with your bucket from bootstrap.
1. Run `terraform init`
1. Run `terraform plan` and review output
1. Run `terraform apply`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| access\_table\_expiration\_ms | Period before tables expire for access logs in milliseconds. Default is 400 days. | number | `"34560000000"` | no |
| access\_transparency\_table\_expiration\_ms | Period before tables expire for access transparency logs in milliseconds. Default is 400 days. | number | `"34560000000"` | no |
| audit\_data\_users | Gsuite or Cloud Identity group that have access to audit logs. | string | n/a | yes |
| billing\_account | The ID of the billing account to associate this project with | string | n/a | yes |
| billing\_data\_users | Gsuite or Cloud Identity group that have access to billing data set. | string | n/a | yes |
| create\_access\_context\_manager\_access\_policy | Whether to create access context manager access policy | bool | `"true"` | no |
| data\_access\_logs\_enabled | Enable Data Access logs of types DATA_READ, DATA_WRITE and ADMIN_READ for all GCP services. Enabling Data Access logs might result in your organization being charged for the additional logs usage. See https://cloud.google.com/logging/docs/audit#data-access | bool | `"true"` | no |
| data\_access\_table\_expiration\_ms | Period before tables expire for data access logs in milliseconds. Default is 30 days. | number | `"2592000000"` | no |
| default\_region | Default region for BigQuery resources. | string | n/a | yes |
| domains\_to\_allow | The list of domains to allow users from in IAM. | list(string) | n/a | yes |
| firewall\_rules\_table\_expiration\_ms | Period before tables expire for firewall rules logs in milliseconds. Default is 400 days. | number | `"34560000000"` | no |
| org\_id | The organization id for the associated services | string | n/a | yes |
| parent\_folder | Optional - if using a folder for testing. | string | `""` | no |
| scc\_notification\_filter | Filter used to SCC Notification, you can see more details how to create filters in https://cloud.google.com/security-command-center/docs/how-to-api-filter-notifications#create-filter | string | `"state=\\\"ACTIVE\\\""` | no |
| scc\_notification\_name | Name of SCC Notification | string | n/a | yes |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module. If set to true you, must ensure that Gcloud Alpha module is installed.) | bool | `"true"` | no |
| system\_event\_table\_expiration\_ms | Period before tables expire for system event logs in milliseconds. Default is 400 days. | number | `"34560000000"` | no |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform. | string | n/a | yes |
| vpc\_flow\_table\_expiration\_ms | Period before tables expire for vpc flow logs in milliseconds. Default is 400 days. | number | `"34560000000"` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
