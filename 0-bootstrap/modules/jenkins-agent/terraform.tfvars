/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// JENKINS MODULE TESTS
org_id = "889612674382"

folder_id = "988743324954"
billing_account = "00080D-89CF65-59BA66"
group_org_admins = "all-admin@mtothel.com"

terraform_sa_email = "sa-terraform-seed-01@prj-seed-manually-created.iam.gserviceaccount.com"
terraform_sa_name = "sa-terraform-seed-01"
terraform_state_bucket = "terraform-state"

jenkins_master_ip_addresses = ["0.0.0.0/0", "10.1.0.6/32"]
jenkins_agent_gce_subnetwork_cidr_range = "10.3.0.0/24"
jenkins_agent_gce_private_ip_address = "10.3.0.6"
nat_bgp_asn = "64514"

jenkins_agent_sa_email = "jenkins-agent-gce-2"

jenkins_agent_gce_ssh_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkliekch0AxykbGkla1eXADCYPQFOkTZctzFuLtgD5Ko5j0zOwQPHgVkM+FOfRi2PF6MuiNDyRfm7ddADzwjtYzq1Dx9oudgZv5ToPxPwXAbSyJMXacebA+kPY/zl0q4SiyWRI5TNzKTZtGQrKktj82GUAcBcTCdqgDN4qLS+LLNeqi0sSPpYK1BSKnu5Oki8ejelQENS6ib5HcBEo9NMiZaUlm18uWHZs44XyYxR250JkIFLyJ33wziAOxjBpkHCAG1t/tqkIYxVEQO0t71wliWWlOiPYP6i/yBVCzWPuu+bp0EBYrEtvQ+u3Cx7pC1NO6kno428l2z/UMzLPx5NN jenkins"

