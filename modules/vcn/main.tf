# Create VCN

resource "oci_core_virtual_network" "vcn" {
  cidr_block = "10.0.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name = "web-hub"
  dns_label      = "tfexamplevcn"
}

# Create internet gateway to allow public internet traffic

resource "oci_core_internet_gateway" "ig" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "ig-gateway"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
}

# Create route table to connect vcn to internet gateway

resource "oci_core_route_table" "rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  display_name = "rt"
  route_rules {
    cidr_block = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.ig.id}"
  }
}

# Create security list to allow internet access from compute and ssh access

resource "oci_core_security_list" "sl" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "sl"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  egress_security_rules = [{
    destination = "0.0.0.0/0"
    protocol = "6"
  },
  {
    tcp_options {
      "max" = 5000
      "min" = 5000
    }
    protocol = "6"
    destination = "10.0.0.0/24"
  },
  {
    tcp_options {
      "max" = 5000
      "min" = 5000
    }
    protocol = "6"
    destination = "10.0.1.0/24"
  }
  ]
  ingress_security_rules = [{
    tcp_options {
      "max" = 22
      "min" = 22
    }
    protocol = "6"
    source = "0.0.0.0/0"
  },
  {
    tcp_options {
      "max" = 1521
      "min" = 1521
    }
    protocol = "6"
    source = "0.0.0.0/0"
  },
  {
    tcp_options {
      "max" = 80
      "min" = 80
    }
    protocol = "6"
    source = "0.0.0.0/0"
  },
  {
    tcp_options {
      "max" = 5000
      "min" = 5000
    }
    protocol = "6"
    source = "10.0.0.0/24"
  },
  {
    tcp_options {
      "max" = 5000
      "min" = 5000
    }
    protocol = "6"
    source = "10.0.1.0/24"
  }
  ]
}

# Create subnet in vcn

resource "oci_core_subnet" "subnet_ad1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2],"name")}"
  cidr_block = "10.0.0.0/24"
  display_name = "subnet_ad1"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  dhcp_options_id = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
  route_table_id = "${oci_core_route_table.rt.id}"
  security_list_ids = ["${oci_core_security_list.sl.id}"]
  dns_label         = "adsubnet1"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_core_subnet" "subnet_ad2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1],"name")}"
  cidr_block = "10.0.1.0/24"
  display_name = "subnet_ad2"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  dhcp_options_id = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
  route_table_id = "${oci_core_route_table.rt.id}"
  security_list_ids = ["${oci_core_security_list.sl.id}"]
  dns_label         = "adsubnet2"
   provisioner "local-exec" {
    command = "sleep 5"
  }
}