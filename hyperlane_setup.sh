#!/bin/bash

# Kiểm tra & cài đặt Docker
echo "=== Kiểm tra Docker ==="
if ! [ -x "$(command -v docker)" ]; then
    echo "Docker không được cài đặt. Bắt đầu cài đặt Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker đã được cài đặt thành công."
else
    echo "Docker đã được cài đặt. Bỏ qua."
fi

# Kiểm tra & cài đặt NVM và Node.js
echo "=== Kiểm tra NVM và Node.js ==="
if ! [ -x "$(command -v nvm)" ]; then
    echo "NVM không được cài đặt. Bắt đầu cài đặt NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
else
    echo "NVM đã được cài đặt. Bỏ qua."
fi

if ! [ -x "$(command -v node)" ]; then
    echo "Node.js không được cài đặt. Bắt đầu cài đặt Node.js..."
    nvm install 20
else
    echo "Node.js đã được cài đặt. Bỏ qua."
fi

# Cài đặt Hyperlane CLI
echo "=== Kiểm tra Hyperlane CLI ==="
if ! [ -x "$(command -v hyperlane)" ]; then
    echo "Hyperlane CLI không được cài đặt. Bắt đầu cài đặt..."
    npm install -g @hyperlane-xyz/cli
else
    echo "Hyperlane CLI đã được cài đặt. Bỏ qua."
fi

# Kéo hình ảnh Docker Hyperlane
echo "=== Kiểm tra hình ảnh Docker Hyperlane ==="
if ! docker images | grep -q "gcr.io/abacus-labs-dev/hyperlane-agent"; then
    echo "Hình ảnh Docker Hyperlane chưa tồn tại. Bắt đầu tải về..."
    docker pull --platform linux/amd64 gcr.io/abacus-labs-dev/hyperlane-agent:agents-v1.0.0
else
    echo "Hình ảnh Docker Hyperlane đã tồn tại. Bỏ qua."
fi

# Yêu cầu thông tin từ người dùng
echo "=== Nhập thông tin cấu hình ==="
read -p "Nhập tên container: " container_name
read -p "Nhập tên validator: " validator_name
read -p "Nhập Private Key (dạng 0x...): " private_key
read -p "Nhập URL RPC (vd: https://base-mainnet.g.alchemy.com/v2/YOUR_KEY): " rpc_url

# Tạo thư mục lưu trữ dữ liệu
data_dir="/opt/hyperlane_db_base/$validator_name"
echo "Tạo thư mục lưu trữ dữ liệu tại $data_dir..."
sudo mkdir -p "$data_dir"
sudo chmod -R 777 "$data_dir"

# Chạy container Hyperlane
echo "=== Chạy container Hyperlane ==="
docker run -d \
    --name "$container_name" \
    --mount type=bind,source="$data_dir",target=/hyperlane_db_base \
    gcr.io/abacus-labs-dev/hyperlane-agent:agents-v1.0.0 \
    ./validator \
    --db /hyperlane_db_base \
    --originChainName base \
    --reorgPeriod 1 \
    --validator.id "$validator_name" \
    --checkpointSyncer.type localStorage \
    --checkpointSyncer.folder base \
    --checkpointSyncer.path /hyperlane_db_base/base_checkpoints \
    --validator.key "$private_key" \
    --chains.base.signer.key "$private_key" \
    --chains.base.customRpcUrls "$rpc_url"

# Xác nhận kết quả
if [ $? -eq 0 ]; then
    echo "Container Hyperlane đã được khởi chạy thành công!"
    echo "Tên container: $container_name"
    echo "Thư mục dữ liệu: $data_dir"
else
    echo "Có lỗi xảy ra khi khởi chạy container Hyperlane."
fi
