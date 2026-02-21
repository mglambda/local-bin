#!/bin/bash

# --- CONFIGURATION ---
SSH_USER="u0_a345"
SSH_PORT="8022"
# ---------------------

# Colors for feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# 1. Check dependencies
if ! command -v nmap &> /dev/null; then
    error "nmap is not installed. Please install it (e.g., sudo apt install nmap)."
fi

# 2. Find local IP and determine subnet
log "Identifying local network configuration..."
# Get the IP used for the default route
LOCAL_IP=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+')

if [ -z "$LOCAL_IP" ]; then
    error "Could not determine local IP address. Are you connected to a network?"
fi

# Extract the first three octets to create a /24 subnet (e.g., 192.168.1.0/24)
SUBNET=$(echo "$LOCAL_IP" | cut -d. -f1-3)
log "Local IP: $LOCAL_IP | Scanning Subnet: $SUBNET.0/24"

# 3. Scan the network
log "Scanning network for active hosts (this may take a few seconds)..."
# We parse nmap output for "Nmap scan report for [hostname] (IP)" or just "Nmap scan report for IP"
mapfile -t SCAN_RESULTS < <(nmap -sn "$SUBNET.0/24" | grep "Nmap scan report for")

if [ ${#SCAN_RESULTS[@]} -eq 0 ]; then
    error "No hosts found on the network."
fi

# 4. Parse results into a clean list
HOST_LABELS=()
HOST_IPS=()

for line in "${SCAN_RESULTS[@]}"; do
    # Extract IP (usually inside parens if hostname exists, or at the end if not)
    IP=$(echo "$line" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}')
    
    # Extract Hostname (everything between "for " and the IP/end of line)
    HOSTNAME=$(echo "$line" | sed 's/Nmap scan report for //g' | sed "s/($IP)//g" | xargs)
    
    if [ -z "$HOSTNAME" ] || [ "$HOSTNAME" == "$IP" ]; then
        LABEL="Unknown Host ($IP)"
    else
        LABEL="$HOSTNAME ($IP)"
    fi
    
    HOST_LABELS+=("$LABEL")
    HOST_IPS+=("$IP")
done

# 5. Present Menu
echo ""
echo "------------------------------------------"
echo "Select your Android device from the list:"
echo "------------------------------------------"

PS3="Enter number (or 'q' to quit): "
select opt in "${HOST_LABELS[@]}"; do
    if [[ $REPLY == "q" ]]; then
        log "Exiting."
        exit 0
    elif [ -n "$opt" ]; then
        INDEX=$((REPLY-1))
        SELECTED_IP=${HOST_IPS[$INDEX]}
        break
    else
        echo "Invalid selection."
    fi
done

# 6. Execute SSH
success "Connecting to $SELECTED_IP..."
ssh -p "$SSH_PORT" "$SSH_USER@$SELECTED_IP"
