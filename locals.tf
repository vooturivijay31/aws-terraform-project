locals {
  environment_config = {
    dev = {
      desired_instances = 1
      min_instances     = 1
      max_instances     = 1
    }

    prod = {
      desired_instances = 2
      min_instances     = 2
      max_instances     = 2
    }
  }

  desired_instances = local.environment_config[terraform.workspace].desired_instances
  min_instances     = local.environment_config[terraform.workspace].min_instances
  max_instances     = local.environment_config[terraform.workspace].max_instances
}