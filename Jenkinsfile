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

pipeline {
  agent {
    label 'gce-agent'
  }
  environment {
    // GOOGLE_APPLICATION_CREDENTIALS = "/home/katiew/my-key.json"
    HOME                           = "/home"
  }
  stages {
    // [START tf-init, tf-validate]
    stage('TF init & validate') {
      //when { anyOf {branch "prod";branch "dev";changeRequest();branch "feature/validator_stage" } }
      steps {
        sh '''

        cd 0-bootstrap/modules/jenkins-agent/
        echo "WE GOT TO THE FOLDER - 1"
        terraform init
        terraform plan --out=terraform.tfplan
        echo "THE PLAN IS COMPLETE - 2"
        
        terraform show -json ./terraform.tfplan > ./terraform.tfplan.json
        echo "THE PLAN IS SHOWN - 3"
        
        #set -e

        active_account=""
        function get-active-account() {
          active_account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2> /dev/null)
        }

        function activate-service-key() {
          rootdir=/root/.config/gcloud-config
          mkdir -p $rootdir
          tmpdir=$(mktemp -d "$rootdir/servicekey.XXXXXXXX")
          trap "rm -rf $tmpdir" EXIT
          echo ${GCLOUD_SERVICE_KEY} | base64 --decode -i > ${tmpdir}/gcloud-service-key.json
          gcloud auth activate-service-account --key-file ${tmpdir}/gcloud-service-key.json --quiet
          get-active-account
        }

        function service-account-usage() {
          cat <<-EOF
        No account is set. This is either provided by the Google cloud builder environment, or by providing a
        key file through environment variables, e.g. set
          GCLOUD_SERVICE_KEY=<base64 encoded service account key file>
        EOF
          exit 1
        }

        function account-active-warning() {
          cat <<-EOF
        A service account key file has been provided in the environment variable GCLOUD_SERVICE_KEY. This account will
        be activated, which will override the account already activated in this container.
        This usually happens if you've defined the GCLOUD_SERVICE_KEY environment variable in a cloudbuild.yaml file & this is
        executing in a Google cloud builder environment.
        EOF
        }

        get-active-account
        if [[ (! -z "$active_account") &&  (! -z "$GCLOUD_SERVICE_KEY") ]]; then
          account-active-warning
          activate-service-key
        elif [[ (-z "$active_account") && (! -z "$GCLOUD_SERVICE_KEY") ]]; then
          activate-service-key
        elif [[ (-z "$active_account") &&  (-z "$GCLOUD_SERVICE_KEY") ]]; then
          echo "no active account and no key"
          service-account-usage
        fi

        echo "Running: terraform $@"
        #terraform "$@"
        terraform apply ./terraform.tfplan
        echo "THE PLAN HAS BEEN APPLIED - 4"
        '''
      }
    }
    // [END tf-init, tf-validate]

    // [START tf-plan]
    stage('TF plan') {
      when { anyOf {branch "prod";branch "dev";changeRequest();branch "feature/validator_stage" } }
      steps {
        sh '''
        if [[ $CHANGE_TARGET ]]; then
          TARGET_ENV=$CHANGE_TARGET
        else
          TARGET_ENV=$BRANCH_NAME
        fi

        # if [ -d "example-pipelines/environments/${TARGET_ENV}/" ]; then
        if [ -d "example-pipelines/environments/dev/" ]; then
          # cd example-pipelines/environments/${TARGET_ENV}
          cd example-pipelines/environments/dev
          terraform plan --out=terraform.tfplan
          terraform show -json ./terraform.tfplan > ./terraform.tfplan.json
        else
          echo "*************** SKIPPING PLAN ******************"
          echo "Branch '$TARGET_ENV' does not represent an official environment."
          echo "*************************************************"
          exit 1
        fi'''
      }
    }
    // [END tf-plan]

    // [START tf-validator]
    stage('TF Validator') {
      when { anyOf {branch "prod";branch "dev";changeRequest();branch "feature/validator_stage" } }
      environment {
        HOME        = "home/katiew"
        // The below will be defined in terraform vars
        // path to policies repo
        POLICY_PATH = "/home/policy-library"
      }
      steps {
        sh '''
        TARGET_ENV=$BRANCH_NAME

        gsutil cp gs://terraform-validator/releases/2020-03-05/terraform-validator-linux-amd64 .
        chmod 755 terraform-validator-linux-amd64

        # if [ -d "example-pipelines/environments/${TARGET_ENV}/" ]; then
        if [ -d "example-pipelines/environments/dev/" ]; then
          # cd example-pipelines/environments/${TARGET_ENV}
          cd example-pipelines/environments/dev
          ./terraform-validator-linux-amd64 validate ./terraform.tfplan.json --policy-path ${POLICY_PATH}
        fi
        '''
      }
    }
    // [END tf-validator]

    // [START tf-apply]
    stage('TF Apply') {
      when { anyOf {branch "prod";branch "dev";branch "feature/validator_stage" } }
      steps {
        sh '''
        TARGET_ENV=$BRANCH_NAME

        # if [ -d "example-pipelines/environments/${TARGET_ENV}/" ]; then
        if [ -d "example-pipelines/environments/dev/" ]; then
          # cd example-pipelines/environments/${TARGET_ENV}
          cd example-pipelines/environments/dev
          terraform apply ./terraform.tfplan
        else
          echo "*************** SKIPPING APPLY ******************"
          echo "Branch '$TARGET_ENV' does not represent an official environment."
          echo "*************************************************"
        fi'''
      }
    }
    // [END tf-apply]
  }
}
