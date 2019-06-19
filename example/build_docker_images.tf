module "build_docker_images" {
  source = "./modules/docker-build-deploy-pipeline"

  principals_full_access = [] // This needs the codedeploy, codepipeline role
  ecr_repo_names         = ["colorteller", "gateway"]

  ecr_repo_source_paths = {
    "colorteller" = "${path.module}/apps/src/colorteller"
    "gateway"     = "${path.module}/apps/src/gateway"
  }
}

output "image_repos" {
  value = "${module.build_docker_images.registry_urls}"
}