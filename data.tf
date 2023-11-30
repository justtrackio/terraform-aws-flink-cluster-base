data "aws_eks_cluster" "cluster" {
  name = "${module.this.organizational_unit}-${module.this.stage}"
}
