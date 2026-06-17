package pipeline

# Policy: A production deployment stage must be preceded by a staging stage.
# This ensures every change is validated in a lower environment before
# reaching production.

deny[msg] {
  stage := input.pipeline.stages[_].stage
  stage.type == "Deployment"
  is_production(stage)
  not has_staging_stage
  msg := sprintf(
    "Production stage '%s' requires a staging deployment stage to run first. Add a staging stage before promoting to production.",
    [stage.name]
  )
}

is_production(stage) {
  contains(lower(stage.name), "prod")
}

is_production(stage) {
  contains(lower(stage.spec.environment.environmentRef), "prod")
}

has_staging_stage {
  stage := input.pipeline.stages[_].stage
  stage.type == "Deployment"
  contains(lower(stage.name), "staging")
}

has_staging_stage {
  stage := input.pipeline.stages[_].stage
  stage.type == "Deployment"
  contains(lower(stage.spec.environment.environmentRef), "staging")
}
