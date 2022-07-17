## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.79.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_default_route_table.route_table](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_default_route_table) | resource |
| [oci_core_instance.instance](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.internet_gateway](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_security_list.security_list](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.subnet](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.vcn](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_vcn) | resource |
| [oci_identity_availability_domain.ad](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domain) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_domain_number"></a> [availability\_domain\_number](#input\_availability\_domain\_number) | The number of the Availability Domain | `number` | `1` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | The OCID of the compartment. Use OCID from tenancy as fallback | `string` | n/a | yes |
| <a name="input_ingress_allowed_tcp"></a> [ingress\_allowed\_tcp](#input\_ingress\_allowed\_tcp) | List of allowed TCP ingress ports | `list(number)` | <pre>[<br>  22,<br>  443,<br>  80<br>]</pre> | no |
| <a name="input_ingress_allowed_udp"></a> [ingress\_allowed\_udp](#input\_ingress\_allowed\_udp) | List of allowed UDP ingress ports | `list(number)` | <pre>[<br>  51820,<br>  20560,<br>  27015,<br>  7777,<br>  8080<br>]</pre> | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create | `number` | `3` | no |
| <a name="input_instance_image_ocid"></a> [instance\_image\_ocid](#input\_instance\_image\_ocid) | Image OCID. List available: https://docs.cloud.oracle.com/en-us/iaas/images/image/cc81a889-bc7f-4b70-b8e7-0503812665be/ | `list(string)` | <pre>[<br>  "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaawohyyavvqh2xxi44dwsu2ysqamht2yj54hynxv2bdhltdby6i7xq",<br>  "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa43nhxgl7mm57gssiqc4ajotp6awanjxn2m2cbju7qyic6cm3rtsq",<br>  "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa43nhxgl7mm57gssiqc4ajotp6awanjxn2m2cbju7qyic6cm3rtsq"<br>]</pre> | no |
| <a name="input_instance_shape"></a> [instance\_shape](#input\_instance\_shape) | The shape of the instance. The shape determines the number of CPUs and the amount of memory allocated to the instance. | `list(string)` | <pre>[<br>  "VM.Standard.A1.Flex",<br>  "VM.Standard.E2.1.Micro",<br>  "VM.Standard.E2.1.Micro"<br>]</pre> | no |
| <a name="input_instance_shape_config"></a> [instance\_shape\_config](#input\_instance\_shape\_config) | Custom shape configuration. | <pre>list(object({<br>    memory_in_gbs = number,<br>    ocpus         = number<br>  }))</pre> | <pre>[<br>  {<br>    "memory_in_gbs": 24,<br>    "ocpus": 4<br>  },<br>  {<br>    "memory_in_gbs": 1,<br>    "ocpus": 1<br>  },<br>  {<br>    "memory_in_gbs": 1,<br>    "ocpus": 1<br>  }<br>]</pre> | no |
| <a name="input_oracle_api_key_fingerprint"></a> [oracle\_api\_key\_fingerprint](#input\_oracle\_api\_key\_fingerprint) | Oracle's key fingerprint | `string` | n/a | yes |
| <a name="input_oracle_api_private_key_path"></a> [oracle\_api\_private\_key\_path](#input\_oracle\_api\_private\_key\_path) | Path to Oracle's private key | `string` | n/a | yes |
| <a name="input_prefix_display_name"></a> [prefix\_display\_name](#input\_prefix\_display\_name) | Prefix for resources display names | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | List available: https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm | `string` | `"sa-saopaulo-1"` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to the private key of the ssh key pair | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Public key signature of the ssh key pair | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The OCID of the tenancy | `string` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | The OCID of the user | `string` | n/a | yes |
| <a name="input_vcn_cidr_block"></a> [vcn\_cidr\_block](#input\_vcn\_cidr\_block) | IPv4 CIDR block associated with the VCN. | `string` | `"10.1.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_display_name"></a> [instance\_display\_name](#output\_instance\_display\_name) | Display name of created instances. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | OCID of created instances. |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private IPs of created instances. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IPs of created instances. |
