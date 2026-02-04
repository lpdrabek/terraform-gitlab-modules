# ==== Module: __MODULE_NAME__ ====
terraform:validate:__MODULE_NAME__:
  stage: validate
  image:
    name: hashicorp/terraform:${TERRAFORM_VERSION}
    entrypoint: [""]
  script:
    - cd __MODULE_PATH__
    - terraform init -backend=false
    - terraform validate
  cache:
    key: terraform-__MODULE_NAME__-${CI_COMMIT_REF_SLUG}
    paths:
      - __MODULE_PATH__/.terraform
      - __MODULE_PATH__/.terraform.lock.hcl

opentofu:validate:__MODULE_NAME__:
  stage: validate
  image:
    name: ghcr.io/opentofu/opentofu:${OPENTOFU_VERSION}
    entrypoint: [""]
  script:
    - cd __MODULE_PATH__
    - tofu init -backend=false
    - tofu validate
  cache:
    key: opentofu-__MODULE_NAME__-${CI_COMMIT_REF_SLUG}
    paths:
      - __MODULE_PATH__/.terraform
      - __MODULE_PATH__/.terraform.lock.hcl

tflint:__MODULE_NAME__:
  stage: validate
  image:
    name: ghcr.io/terraform-linters/tflint:${TFLINT_VERSION}
    entrypoint: [""]
  script:
    - tflint --init
    - cd __MODULE_PATH__
    - tflint --format compact

opentofu:test:__MODULE_NAME__:
  stage: test
  image:
    name: ghcr.io/opentofu/opentofu:${OPENTOFU_VERSION}
    entrypoint: [""]
  needs:
    - job: opentofu:validate:__MODULE_NAME__
      artifacts: false
  rules:
    - exists:
        - __MODULE_PATH__/tests/*.tftest.hcl
  script:
    - cd __MODULE_PATH__
    - tofu init -backend=false
    - tofu test
  cache:
    key: opentofu-test-__MODULE_NAME__-${CI_COMMIT_REF_SLUG}
    paths:
      - __MODULE_PATH__/.terraform
      - __MODULE_PATH__/.terraform.lock.hcl
