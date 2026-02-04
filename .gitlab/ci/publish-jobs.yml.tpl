# ==== Publish: __MODULE_NAME__ ====
publish:__MODULE_NAME__:
  stage: publish
  image: alpine:latest
  before_script:
    - apk add --no-cache curl tar
  script:
    - |
      MODULE_VERSION=$(echo "${CI_COMMIT_TAG}" | sed 's/.*_//')
      echo "Publishing __MODULE_NAME__ version ${MODULE_VERSION}..."

      cd "${CI_PROJECT_DIR}/__MODULE_PATH__"
      tar -czf "/tmp/__MODULE_NAME__.tar.gz" .

      curl --fail-with-body --header "JOB-TOKEN: ${CI_JOB_TOKEN}" \
           --upload-file "/tmp/__MODULE_NAME__.tar.gz" \
           "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/terraform/modules/__MODULE_NAME__/gitlab/${MODULE_VERSION}/file"

      echo ""
      echo "Published __MODULE_NAME__ v${MODULE_VERSION}"
