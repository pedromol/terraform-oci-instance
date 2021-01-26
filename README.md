## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| oci | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment\_ocid | The OCID of the compartment. Use OCID from tenancy as fallback | `string` | n/a | yes |
| oracle\_api\_key\_fingerprint | Oracle's key fingerprint | `string` | n/a | yes |
| oracle\_api\_private\_key\_path | Path to Oracle's private key | `string` | n/a | yes |
| ssh\_private\_key\_path | Path to the private key of the ssh key pair | `string` | n/a | yes |
| ssh\_public\_key | Public key signature of the ssh key pair | `string` | n/a | yes |
| tenancy\_ocid | The OCID of the tenancy | `string` | n/a | yes |
| user\_ocid | The OCID of the user | `string` | n/a | yes |
| availability\_domain\_number | The number of the Availability Domain | `number` | `1` | no |
| instance\_count | Number of instances to spawn | `number` | `2` | no |
| instance\_image\_ocid | Image OCID. List available: https://docs.cloud.oracle.com/en-us/iaas/images/image/cc81a889-bc7f-4b70-b8e7-0503812665be/ | `map(string)` | <pre>{<br>  "sa-saopaulo-1": "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa43nhxgl7mm57gssiqc4ajotp6awanjxn2m2cbju7qyic6cm3rtsq"<br>}</pre> | no |
| instance\_shape | The shape of the instance. The shape determines the number of CPUs and the amount of memory allocated to the instance. | `string` | `"VM.Standard.E2.1.Micro"` | no |
| prefix\_display\_name | Prefix for resources display names | `string` | `""` | no |
| region | List available: https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm | `string` | `"sa-saopaulo-1"` | no |
| vcn\_cidr\_block | IPv4 CIDR block associated with the VCN. | `string` | `"10.1.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| connect\_with\_ssh | n/a |
| connect\_with\_vnc | n/a |
| instance\_id | OCID of created instances. |
| private\_ip | Private IPs of created instances. |
| public\_ip | Public IPs of created instances. |

