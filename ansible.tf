data "template_file" "host_vars_template" {
  template = "${file("${path.module}/templates/host_vars.yml")}"

  # depends_on = ["module.db"]

  vars {
    db_hostname = "${module.db.this_db_instance_address}"
  }
}

resource "null_resource" "host_vars" {
  triggers {
    template_rendered = "${data.template_file.host_vars_template.rendered}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.host_vars_template.rendered}' > ansible/host_vars/${var.servername}"
  }
}

data "template_file" "inventory_template" {
  template = "${file("${path.module}/templates/inventory")}"

  # depends_on = ["aws_eip.xwiki_eip"]

  vars {
    servername = "${var.servername}"
    host_ip    = "${aws_eip.xwiki_eip.public_ip}"
  }
}

resource "null_resource" "inventory" {
  triggers {
    template_rendered = "${data.template_file.inventory_template.rendered}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory_template.rendered}' > ansible/inventory-${var.servername}"
  }
}
