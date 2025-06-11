#!/bin/bash

# ============================================================================
# Firewall Configuration Automation System - Foundation
# ============================================================================

set -euo pipefail

# Project Structure Setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/config"
LOG_DIR="${SCRIPT_DIR}/logs"
BACKUP_DIR="${SCRIPT_DIR}/backups"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"

# Create directory structure
create_project_structure() {
    echo "Creating project directories..."
    mkdir -p "$CONFIG_DIR" "$LOG_DIR" "$BACKUP_DIR" "$TEMPLATES_DIR"
    
    # Create sample configuration files
    cat > "${CONFIG_DIR}/servers.json" << 'EOF'
{
    "servers": [
        {
            "name": "web-server-1",
            "ip": "192.168.1.100",
            "user": "admin",
            "role": "web"
        },
        {
            "name": "db-server-1", 
            "ip": "192.168.1.101",
            "user": "admin",
            "role": "database"
        }
    ]
}
EOF
    
    cat > "${CONFIG_DIR}/firewall_rules.json" << 'EOF'
{
    "web": {
        "allow": [
            {"port": "22", "protocol": "tcp", "source": "any"},
            {"port": "80", "protocol": "tcp", "source": "any"},
            {"port": "443", "protocol": "tcp", "source": "any"}
        ],
        "deny": [
            {"port": "3306", "protocol": "tcp", "source": "any"}
        ]
    },
    "database": {
        "allow": [
            {"port": "22", "protocol": "tcp", "source": "192.168.1.0/24"},
            {"port": "3306", "protocol": "tcp", "source": "192.168.1.0/24"}
        ],
        "deny": [
            {"port": "80", "protocol": "tcp", "source": "any"}
        ]
    }
}
EOF
    
    echo "Project structure created successfully!"
}

# Logging Functions
LOG_FILE="${LOG_DIR}/firewall_automation_$(date +%Y%m%d_%H%M%S).log"

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" | tee -a "$LOG_FILE" >&2
}

log_success() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" | tee -a "$LOG_FILE"
}

# Firewall Detection Function
detect_firewall() {
    local server_ip="$1"
    local server_user="$2"
    
    log_info "Detecting firewall on $server_ip"
    
    # Check for different firewall services via SSH
    if ssh -o ConnectTimeout=10 "$server_user@$server_ip" "command -v ufw >/dev/null 2>&1"; then
        echo "ufw"
    elif ssh -o ConnectTimeout=10 "$server_user@$server_ip" "command -v firewall-cmd >/dev/null 2>&1"; then
        echo "firewalld"
    elif ssh -o ConnectTimeout=10 "$server_user@$server_ip" "command -v iptables >/dev/null 2>&1"; then
        echo "iptables"
    else
        echo "unknown"
    fi
}

# SSH Connection Test
test_ssh_connection() {
    local server_ip="$1"
    local server_user="$2"
    
    log_info "Testing SSH connection to $server_user@$server_ip"
    
    if ssh -o ConnectTimeout=10 -o BatchMode=yes "$server_user@$server_ip" "echo 'Connection successful'" >/dev/null 2>&1; then
        log_success "SSH connection to $server_ip successful"
        return 0
    else
        log_error "SSH connection to $server_ip failed"
        return 1
    fi
}

# Configuration Parser (simplified JSON reading)
parse_servers_config() {
    local config_file="${CONFIG_DIR}/servers.json"
    
    if [[ ! -f "$config_file" ]]; then
        log_error "Configuration file not found: $config_file"
        return 1
    fi
    
    # Extract server information (basic parsing)
    grep -o '"ip": "[^"]*"' "$config_file" | cut -d'"' -f4
}

# Backup Function
backup_firewall_rules() {
    local server_ip="$1"
    local server_user="$2"
    local firewall_type="$3"
    local backup_file="${BACKUP_DIR}/backup_${server_ip}_$(date +%Y%m%d_%H%M%S).txt"
    
    log_info "Creating backup for $server_ip ($firewall_type)"
    
    case "$firewall_type" in
        "ufw")
            ssh "$server_user@$server_ip" "sudo ufw status numbered" > "$backup_file"
            ;;
        "firewalld")
            ssh "$server_user@$server_ip" "sudo firewall-cmd --list-all" > "$backup_file"
            ;;
        "iptables")
            ssh "$server_user@$server_ip" "sudo iptables -L -n" > "$backup_file"
            ;;
        *)
            log_error "Unknown firewall type: $firewall_type"
            return 1
            ;;
    esac
    
    log_success "Backup created: $backup_file"
}

# Main execution function
main() {
    echo "=== Firewall Configuration Automation System ==="
    
    # Create project structure
    create_project_structure
    
    # Test the foundation components
    log_info "Starting firewall automation system..."
    
    # Parse server configuration
    log_info "Reading server configuration..."
    server_ips=($(parse_servers_config))
    
    for ip in "${server_ips[@]}"; do
        echo "Processing server: $ip"
        
        # Test SSH connection (you'll need to set up SSH keys)
        # if test_ssh_connection "$ip" "admin"; then
        #     firewall_type=$(detect_firewall "$ip" "admin")
        #     log_info "Detected firewall: $firewall_type on $ip"
        #     backup_firewall_rules "$ip" "admin" "$firewall_type"
        # fi
        
        # For now, just log the server
        log_info "Server $ip added to processing queue"
    done
    
    log_success "Foundation setup complete!"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi