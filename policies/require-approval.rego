package pipeline

# Policy: Every Deployment stage must have at least one Approval step
# before any deployment execution step.

deny[msg] {
  stage := input.pipeline.stages[_].stage
  stage.type == "Deployment"
  not has_approval(stage)
  msg := sprintf(
    "Deployment stage '%s' is missing an approval step. Add a HarnessApproval or JiraApproval step before deploying.",
    [stage.name]
  )
}

has_approval(stage) {
  step := stage.spec.execution.steps[_].step
  step.type == "HarnessApproval"
}

has_approval(stage) {
  step := stage.spec.execution.steps[_].step
  step.type == "JiraApproval"
}
