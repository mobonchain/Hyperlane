#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

echo -e "${BLUE}Starting Hyperlane Setup...${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Step 1: Check and install Docker
if command_exists docker; then
    echo -e "${GREEN}Docker is already installed.${NC}"
else
    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Step 2: Check and install NVM and Node.js
if command_exists node && command_exists nvm; then
    echo -e "${GREEN}Node.js and NVM are already installed.${NC}"
else
    echo -e "${YELLOW}Installing NVM and Node.js...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    nvm install 20
fi

# Step 3: Install Hyperlane CLI
if command_exists hyperlane; then
    echo -e "${GREEN}Hyperlane CLI is already installed.${NC}"
else
    echo -e "${YELLOW}Installing Hyperlane CLI...${NC}"
    npm install -g @hyperlane-xyz/cli
fi

# Step 4: Pull Hyperlane Docker image
IMAGE_NAME="gcr.io/abacus-labs-dev/hyperlane-agent:agents-v1.0.0"
if docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    echo -e "${GREEN}Hyperlane Docker image is already pulled.${NC}"
else
    echo -e "${YELLOW}Pulling Hyperlane Docker image...${NC}"
    docker pull --platform linux/amd64 "$IMAGE_NAME"
fi

# Step 5: Gather user inputs
read -p "Enter the container name: " CONTAINER_NAME
read -p "Enter the validator name: " VALIDATOR_NAME
read -p "Enter your private key: " PRIVATE_KEY
read -p "Enter your RPC URL: " RPC_URL

# Step 6: Create and set permissions for the validator directory
VALIDATOR_DIR="/opt/hyperlane_db_polygon/$VALIDATOR_NAME"

# Create the directory for the validator
echo -e "${YELLOW}Creating directory for validator...${NC}"
sudo mkdir -p "$VALIDATOR_DIR"

# Set read/write/execute permissions for all users
echo -e "${YELLOW}Setting permissions for the validator directory...${NC}"
sudo chmod -R 777 "$VALIDATOR_DIR"

# Step 7: Create and run the Hyperlane container
echo -e "${BLUE}Starting Hyperlane container...${NC}"
docker run -d \
    --name "$CONTAINER_NAME" \
    --mount type=bind,source="$VALIDATOR_DIR",target=/hyperlane_db_polygon \
    "$IMAGE_NAME" \
    ./validator \
    --db /hyperlane_db_polygon \
    --originChainName polygon \
    --reorgPeriod 1 \
    --validator.id "$VALIDATOR_NAME" \
    --checkpointSyncer.type localStorage \
    --checkpointSyncer.folder polygon \
    --checkpointSyncer.path /hyperlane_db_polygon/polygon_checkpoints \
    --validator.key "$PRIVATE_KEY" \
    --chains.polygon.signer.key "$PRIVATE_KEY" \
    --chains.polygon.customRpcUrls "$RPC_URL"

echo -e "${GREEN}Hyperlane container '$CONTAINER_NAME' is now running.${NC}"
