# System Architecture Documentation

## Infrastructure Overview

The red team framework implements a two-tier virtual machine architecture for penetration testing simulation. The infrastructure leverages Vagrant for orchestration and Ansible for configuration management, providing rapid deployment and consistent environment setup.

## Network Topology

The system operates on an isolated private network using the 192.168.56.0/24 address space. This configuration ensures complete isolation from production networks and external internet access.

Network segment details:
- Subnet: 192.168.56.0/24
- Attacker IP: 192.168.56.10
- Target IP: 192.168.56.20
- Gateway: Host-only networking via VirtualBox

## Virtual Machine Specifications

### Attacker Node

Operating System: Debian 12 (Bookworm)
Hostname: attacker
IP Address: 192.168.56.10
Memory: 2048 MB
CPU Cores: 2
Disk: 20 GB dynamic allocation

Installed Tools:
- nmap: Network mapper for service discovery
- hydra: Password cracking utility
- john: Password hash cracker
- hashcat: Advanced password recovery
- masscan: High-speed port scanner
- metasploit-framework: Exploitation framework
- nikto: Web server scanner
- netcat: Network utility for connection testing
- tcpdump: Network packet analyzer

### Target Node

Operating System: Ubuntu 22.04 LTS (Jammy)
Hostname: target
IP Address: 192.168.56.20
Memory: 1024 MB
CPU Cores: 1
Disk: 15 GB dynamic allocation

Running Services:
- SSH (port 22): OpenSSH 8.9p1
- HTTP (port 80): Apache 2.4
- FTP (port 21): vsftpd

Test Accounts:
- admin (password: admin123)
- user1 (password: password)
- testuser (password: test123)

## Automation Framework

### Vagrant Configuration

Vagrant manages virtual machine lifecycle through declarative configuration. The Vagrantfile defines machine specifications, network settings, and initial provisioning steps.

Key configuration elements:
- Base box selection (debian/bookworm64, ubuntu/jammy64)
- Resource allocation (memory, CPU)
- Network interface configuration
- Initial shell provisioning for Python and SSH setup

### Ansible Playbooks

#### Attacker Setup Playbook

Purpose: Configure attacker node with penetration testing tools

Tasks executed:
- System package updates
- Installation of reconnaissance tools
- Password cracking tool deployment
- Network analysis utilities setup
- Log directory creation
- Permission configuration

#### Target Setup Playbook

Purpose: Configure target node with vulnerable services

Tasks executed:
- SSH server installation and configuration
- Web server deployment (Apache)
- FTP server setup (vsftpd)
- Test user account creation
- Intentionally weak security configurations
- Service enablement and startup

#### Attack Playbook

Purpose: Execute SSH brute force attack scenario

Workflow stages:

Phase 1: Reconnaissance
- Nmap service version detection on port 22
- Operating system fingerprinting
- Service banner capture

Phase 2: Attack Preparation
- Username wordlist generation
- Password dictionary compilation
- Attack parameter configuration

Phase 3: Credential Attack
- Hydra SSH brute force execution
- Rate-limited connection attempts
- Real-time progress monitoring

Phase 4: Result Processing
- Successful credential extraction
- Log file generation
- Summary report creation

## Attack Scenario Implementation

### SSH Brute Force Attack

Technical Implementation:

The attack uses hydra with the following parameters:
- Username list: admin, user1, testuser, root
- Password dictionary: common weak passwords
- Thread count: 2 (to avoid detection and rate limiting)
- Wait time: 3 seconds between attempts
- Verbose output enabled for detailed logging

Attack execution flow:
1. Nmap identifies SSH service on target
2. Wordlists are generated on attacker node
3. Hydra initiates connection attempts
4. Each username/password combination is tested
5. Successful authentications are logged
6. Summary report is generated

Results are stored in:
- /var/log/redteam/ssh-bruteforce-results.txt (detailed output)
- /var/log/redteam/nmap-prescan.txt (reconnaissance data)
- /var/log/redteam/attack-summary.txt (executive summary)

## Security Considerations

### Network Isolation

The framework operates on a host-only network adapter provided by VirtualBox. This configuration prevents:
- Outbound internet connectivity from virtual machines
- Access from external networks
- Lateral movement to production systems
- Data exfiltration beyond the host system

### SSH Configuration Management

Ubuntu 22.04 cloud images include hardened SSH configurations that prevent password authentication by default. The framework addresses this through:

1. Removal of cloud-init SSH overrides
2. Explicit password authentication enablement
3. Keyboard-interactive authentication configuration
4. Service restart to apply changes

Configuration file modifications:
- /etc/ssh/sshd_config.d/60-cloudimg-settings.conf (removed)
- /etc/ssh/sshd_config.d/99-enable-password.conf (created)

### Logging and Auditing

All attack activities generate comprehensive logs including:
- Timestamps for each action
- Source and destination IP addresses
- Attempted credentials
- Success/failure status
- Tool output and error messages

Log files are stored persistently on the attacker node for post-attack analysis and reporting.

## Modular Design

The framework architecture supports extensibility through:

Adding new attack scenarios:
Create additional Ansible playbooks in the ansible/ directory following the naming convention attack-[scenario-name].yml

Adding new virtual machines:
Extend the Vagrantfile with additional config.vm.define blocks specifying machine parameters

Customizing tool installations:
Modify setup playbooks to include additional packages or tools as needed

## Performance Characteristics

Resource utilization:
- Total memory: 3 GB (2GB attacker + 1GB target)
- Total disk: approximately 35 GB after provisioning
- Network throughput: Limited by host-only adapter (typically 1 Gbps)

Deployment timing:
- Initial vagrant up: 10-15 minutes (includes box downloads)
- Ansible provisioning: 5-10 minutes per playbook
- Attack execution: 1-3 minutes depending on wordlist size

## Technical Stack Summary

Virtualization Layer:
- VirtualBox 7.2.6 (hypervisor)
- Vagrant 2.x (orchestration)

Configuration Management:
- Ansible 2.17.14 (automation)
- Python 3.10 (Ansible runtime)

Operating Systems:
- Debian 12 (attacker platform)
- Ubuntu 22.04 LTS (target platform)

Attack Tools:
- Hydra 9.4 (credential brute forcing)
- Nmap 7.93 (network reconnaissance)
- Additional tools as specified in playbooks
