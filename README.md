# Red Team Framework

Modular penetration testing framework for academic cybersecurity laboratories.

## Project Overview

This framework provides automated infrastructure deployment and attack simulation capabilities for security training and defensive analysis in controlled environments.

## System Architecture

The framework consists of two virtual machines running in an isolated network:

- Attacker VM (Debian 12): Equipped with penetration testing tools including nmap, hydra, john, and masscan. Resources: 2GB RAM, 2 CPU cores, IP 192.168.56.10
- Target VM (Ubuntu 22.04): Configured with vulnerable services and weak credentials for testing. Resources: 1GB RAM, 1 CPU core, IP 192.168.56.20

Both systems communicate over a private network (192.168.56.0/24) with no external internet access.

## Prerequisites

- VirtualBox 7.x or higher
- Vagrant 2.x or higher
- Ansible 2.17 or higher
- Minimum 8GB system RAM
- 20GB available disk space

## Installation and Setup

Clone the repository and navigate to project directory. Create and start virtual machines using vagrant up command. Configure the attacker system by running ansible-playbook with the setup-attacker.yml file and inventory. Configure the target system similarly using setup-target.yml.

## Running Attack Scenarios

Execute SSH brute force attack using the attack-ssh-bruteforce.yml playbook. View results by accessing the attacker machine through vagrant ssh and examining log files in /var/log/redteam/ directory.

## Available Commands

Start virtual machines with vagrant up. Stop virtual machines with vagrant halt. Restart virtual machines with vagrant reload. Remove virtual machines with vagrant destroy. Access attacker system using vagrant ssh attacker. Access target system using vagrant ssh target.

## Attack Methodology

The SSH brute force scenario follows this workflow:

1. Network reconnaissance using nmap to identify open services
2. Generation of username and password wordlists
3. Automated credential testing with hydra
4. Result logging and analysis

All attack activity is logged to /var/log/redteam/ directory on the attacker machine.

## Project Structure

The project contains a Vagrantfile for VM definitions, ansible directory with inventory and playbook files, docs directory with architecture documentation, and this README file.

## Common Issues

If SSH password authentication fails during attack execution, connect to target VM and remove the cloud-init settings file from /etc/ssh/sshd_config.d/ directory, then create a new configuration file to enable password authentication and restart the SSH service.

If virtual machines are not accessible, use vagrant reload command. If Ansible cannot connect, test connectivity using ansible ping module with the inventory file.

## Security Notice

This framework is designed exclusively for authorized educational use in controlled laboratory environments. Unauthorized penetration testing against systems without explicit permission is illegal. All attack scenarios should only be executed against the included target virtual machine.

The target system is intentionally configured with security weaknesses for educational purposes. These configurations should never be used in production environments.

## Educational Applications

- Penetration testing methodology training
- Security tool familiarization
- Attack and defense technique demonstration
- Cybersecurity curriculum laboratory exercises
- Incident response scenario development

## Future Development

Planned enhancements include additional attack scenarios, blue team detection capabilities, automated reporting, and integration with security information and event management systems.
