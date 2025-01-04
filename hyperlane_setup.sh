#!/bin/bash

echo "Starting Hyperlane Setup..."

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Step 1: Check and install Docker
if command_exists docker; then
    echo "Docker is already installed."
else
    echo "Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Step 2: Check and install NVM and Node.js
if command_exists node && command_exists nvm; then
    echo "Node.js and NVM are already installed."
else
    echo "Installing NVM and Node.js..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    nvm install 20
fi

# Step 3: Install Hyperlane CLI
if command_exists hyperlane; then
    echo "Hyperlane CLI is already installed."
else
    echo "Installing Hyperlane CLI..."
    npm install -g @hyperlane-xyz/cli
fi

# Step 4: Pull Hyperlane Docker image
IMAGE_NAME="gcr.io/abacus-labs-dev/hyperlane-agent:agents-v1.0.0"
if docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    echo "Hyperlane Docker image is already pulled."
else
    echo "Pulling Hyperlane Docker image..."
    docker pull --platform linux/amd64 "$IMAGE_NAME"
fi

# Step 5: Gather user inputs
read -p "Enter the container name: " CONTAINER_NAME
read -p "Enter the validator name: " VALIDATOR_NAME
read -p "Enter your private key: " PRIVATE_KEY
read -p "Enter your RPC URL: " RPC_URL

# Step 6: Create and set permissions for the validator directory
VALIDATOR_DIR="/opt/hyperlane_db_base/$VALIDATOR_NAME"

# Create the directory for the validator
sudo mkdir -p "$VALIDATOR_DIR"

# Set read/write/execute permissions for all users
sudo chmod -R 777 "$VALIDATOR_DIR"

# Step 7: Create and run the Hyperlane container
echo "Starting Hyperlane container..."
docker run -d \
    --name "$CONTAINER_NAME" \
    --mount type=bind,source="$VALIDATOR_DIR",target=/hyperlane_db_base \
    "$IMAGE_NAME" \
    ./validator \
    --db /hyperlane_db_base \
    --originChainName base \
    --reorgPeriod 1 \
    --validator.id "$VALIDATOR_NAME" \
    --checkpointSyncer.type localStorage \
    --checkpointSyncer.folder base \
    --checkpointSyncer.path /hyperlane_db_base/base_checkpoints \
    --validator.key "$PRIVATE_KEY" \
    --chains.base.signer.key "$PRIVATE_KEY" \
    --chains.base.customRpcUrls "$RPC_URL"

echo "Hyperlane container '$CONTAINER_NAME' is now running."
