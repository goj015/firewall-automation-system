# Firewall Configuration Automation System

A comprehensive Bash-based solution for automating firewall rule management across multiple Linux servers. This system provides centralized configuration management, automated deployment, backup/restore capabilities, and comprehensive logging for enterprise security automation.

## 🎯 Project Objectives

- **Automate firewall configuration** across multiple Linux servers simultaneously
- **Ensure consistency** in security policies across infrastructure
- **Reduce manual errors** through standardized rule deployment
- **Provide rollback capabilities** for quick recovery from misconfigurations
- **Support multiple firewall types** (iptables, ufw, firewalld)
- **Enable role-based rule management** for different server types

## ✨ Features

### Core Functionality
- **Multi-Firewall Support**: Automatic detection and management of iptables, ufw, and firewalld
- **Role-Based Configuration**: Different rule sets for web servers, database servers, and application servers
- **Centralized Management**: JSON-based configuration files for servers and rules
- **Secure Deployment**: SSH-based remote execution with key authentication
- **Automated Backups**: Timestamped backups before any configuration changes
- **Rollback Mechanism**: Quick restoration to previous configurations
- **Comprehensive Logging**: Detailed logs with timestamps and severity levels
- **Rule Validation**: Conflict detection and policy consistency checks

### Advanced Features
- **Template-Based Rules**: Predefined templates for common server roles
- **Batch Operations**: Deploy to multiple servers simultaneously
- **Email Notifications**: Alerts for critical security events (configurable)
- **Audit Reports**: Detailed deployment and compliance reports

## 🏗️ Project Structure

```
firewall-automation/
├── firewall_automation.sh      # Main script
├── README.md                   # This file
├── config/                     # Configuration files
│   ├── servers.json           # Server inventory
│   └── firewall_rules.json    # Firewall rules by role
├── logs/                      # Operation logs
├── backups/                   # Firewall configuration backups
└── templates/                 # Rule templates (future enhancement)
```

## 🚀 Quick Start

### Prerequisites

- **Linux/Unix environment** (Linux, macOS, or WSL on Windows)
- **Bash 4.0+**
- **SSH client** with key-based authentication configured
- **sudo access** on target servers
- **Git** for repository management

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/goj015/Midterm-server.git
   cd Midterm-server
   ```

2. **Make the script executable**:
   ```bash
   chmod +x firewall_automation.sh
   ```

3. **Initialize the project structure**:
   ```bash
   ./firewall_automation.sh init
   ```

### Configuration

1. **Configure your servers** in `config/servers.json`:
   ```json
   {
       "servers": [
           {
               "name": "web-server-1",
               "ip": "192.168.1.100",
               "user": "admin",
               "role": "web",
               "ssh_key": "~/.ssh/id_rsa"
           }
       ]
   }
   ```

2. **Define firewall rules** in `config/firewall_rules.json`:
   ```json
   {
       "web": {
           "allow": [
               {"port": "80", "protocol": "tcp", "source": "any", "comment": "HTTP"}
           ]
       }
   }
   ```

## 📖 Usage

### Basic Commands

```bash
# Initialize project structure
./firewall_automation.sh init

# Deploy rules to all servers
./firewall_automation.sh deploy

# Validate current firewall configurations
./firewall_automation.sh validate

# Create backups of all server configurations
./firewall_automation.sh backup

# Generate deployment report
./firewall_automation.sh report

# Show help
./firewall_automation.sh help
```

### Example Workflow

1. **Setup**: Initialize and configure your servers and rules
2. **Deploy**: Apply firewall rules across your infrastructure
3. **Validate**: Verify rules are correctly applied
4. **Monitor**: Check logs and generate reports

## 🔧 Configuration Details

### Server Configuration (`config/servers.json`)

```json
{
    "servers": [
        {
            "name": "unique-server-name",
            "ip": "server-ip-address",
            "user": "ssh-username",
            "role": "server-role",
            "ssh_key": "path-to-private-key"
        }
    ]
}
```

### Rule Configuration (`config/firewall_rules.json`)

```json
{
    "role-name": {
        "allow": [
            {
                "port": "port-number",
                "protocol": "tcp|udp",
                "source": "ip-address|subnet|any",
                "comment": "rule description"
            }
        ],
        "deny": [
            {
                "port": "port-number",
                "protocol": "tcp|udp",
                "source": "ip-address|subnet|any",
                "comment": "rule description"
            }
        ]
    }
}
```

## 🔒 Security Considerations

- **SSH Key Authentication**: Use key-based authentication instead of passwords
- **Principle of Least Privilege**: Configure minimal required access
- **Backup Before Changes**: Always create backups before modifications
- **Audit Logging**: All operations are logged with timestamps
- **Rollback Capability**: Quick recovery from misconfigurations

## 🐛 Troubleshooting

### Common Issues

1. **SSH Connection Failed**
   - Verify SSH keys are properly configured
   - Check network connectivity to target servers
   - Ensure user has sudo privileges

2. **Permission Denied**
   - Make script executable: `chmod +x firewall_automation.sh`
   - Verify sudo access on target servers

3. **Configuration Parse Errors**
   - Validate JSON syntax in configuration files
   - Check for required fields in server/rule definitions

### Logs

Check the logs directory for detailed error information:
```bash
tail -f logs/firewall_automation_*.log
```

## 🔄 Development Roadmap

- [ ] Web-based management interface
- [ ] Integration with configuration management tools (Ansible, Puppet)
- [ ] Support for cloud firewall services (AWS Security Groups, GCP Firewall)
- [ ] Advanced rule conflict detection
- [ ] Automated compliance reporting
- [ ] Multi-environment support (dev, staging, production)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Support

For questions or support, please create an issue in the GitHub repository.

## 🙏 Acknowledgments

- Inspired by the need for consistent security automation
- Built with security best practices in mind
- Designed for enterprise-scale deployments

---

**Last Updated**: $(date)  
**Version**: 1.0.0  
**Author**: Security Automation Team