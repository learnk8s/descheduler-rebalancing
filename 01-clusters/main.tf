module "standard" {
  source = "../modules/cluster"

  name   = "standard"
  region = "eu-west"
}

resource "local_file" "kubeconfig_standard" {
  filename = "../kubeconfig"
  content  = module.standard.kubeconfig
}

