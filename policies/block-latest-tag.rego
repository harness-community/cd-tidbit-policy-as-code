package pipeline

# Policy: Artifact image tag must not be "latest".
# Pinning to a specific version ensures deployments are reproducible
# and prevents unintended changes from being promoted to production.

deny[msg] {
  stage := input.pipeline.stages[_].stage
  stage.type == "Deployment"
  source := stage.spec.service.serviceInputs.serviceDefinition.spec.artifacts.primary.sources[_]
  source.spec.tag == "latest"
  msg := sprintf(
    "Deployment stage '%s' uses the 'latest' image tag. Pin to a specific version tag (e.g. a build number).",
    [stage.name]
  )
}
