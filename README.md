# TelcoKS Enterprise Network Lab

NetBox-driven network automation lab: Terraform (NetBox provider) + AWX +
Ansible, targeting an EVE-NG topology.

## Lab Access

- **EVE-NG Server**: `81.17.100.252`
- **EVE-NG Web UI**: http://81.17.100.252
- **SSH**: `ssh root@81.17.100.252`
- **NetBox**: http://81.17.100.252:8000
- **AWX**: http://81.17.100.252:30080

## Repository Structure

```
terraform/     NetBox-as-code: sites, devices, VLANs, prefixes,
                management/loopback/P2P IP allocations
ansible/        Playbooks, roles, NetBox-driven inventory
collections/    Ansible collection requirements
.github/        CI/CD workflows (Terraform plan/apply)
```

## Source of Truth Model

- **Terraform** declares structural objects in NetBox: sites, device roles,
  device types, devices, VLANs, prefixes, management/loopback/P2P IP
  addresses.
- **NetBox UI** holds operational/design attributes: interface 802.1Q mode,
  tagged/untagged VLANs, cables, FHRP groups, statuses.
- **Ansible/AWX** only *reads* from NetBox (via `netbox.netbox.nb_inventory`
  and `nb_lookup`) and configures devices accordingly. Ansible never writes
  back to NetBox.
