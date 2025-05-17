#!/bin/bash

RED=$'\033[31m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
NC=$'\033[0m'

read -rp "${GREEN}Enter your L1 RPC URL for Sepolia:${NC} " L1_RPC_URL
read -rp "${GREEN}Enter your L1 Beacon (consensus) RPC URL:${NC} " L1_BEACON_URL
read -rp "${GREEN}Enter your Private Key:${NC} " VALIDATOR_PRIVKEY
read -rp "${GREEN}Enter your Address:${NC} " COINBASE_ADDRESS

echo "${BLUE}🔧 Installing Aztec CLI...${NC}"
bash -i <(curl -s https://install.aztec.network)

echo "${BLUE}🔧 Adding Aztec CLI to PATH...${NC}"
echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo "${BLUE}🌐 Setting up Aztec alpha-testnet...${NC}"
aztec-up alpha-testnet

echo "${BLUE}🔒 Configuring firewall (UFW)...${NC}"
ufw allow 22
ufw allow ssh
ufw allow 40400
ufw allow 8080
ufw --force enable

echo "${BLUE}🛠️ Creating systemd service for Aztec Node...${NC}"

SERVICE_FILE="/etc/systemd/system/aztec.service"

sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Aztec Node Service
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME
ExecStart=$HOME/.aztec/bin/aztec start --node --archiver --sequencer \\
  --network alpha-testnet \\
  --l1-rpc-urls $L1_RPC_URL \\
  --l1-consensus-host-urls $L1_BEACON_URL \\
  --sequencer.validatorPrivateKey $VALIDATOR_PRIVKEY \\
  --sequencer.coinbase $COINBASE_ADDRESS \\
  --p2p.p2pIp 0.0.0.0 \\
  --p2p.maxTxPoolSize 1000000000
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable aztec
sudo systemctl start aztec

echo
echo "${GREEN}✅ Installation complete!${NC}"
echo "${YELLOW}Use the command below to check the node status:${NC}"
echo "${BLUE}  systemctl status aztec${NC}"
