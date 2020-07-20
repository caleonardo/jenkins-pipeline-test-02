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
