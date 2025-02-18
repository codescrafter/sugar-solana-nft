#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi

# Run node script (assumes it creates deployer_wallet.json)
echo "Running node script..."
if ! node index; then
  echo "Node script failed."
  exit 1
fi

# Set Solana config
echo "Setting Solana RPC URL..."
solana config set --url "$RPC"

echo "Setting Solana deployer keypair..."
solana config set --keypair ./deployer_wallet.json

# Run Sugar commands
echo "Validating..."
sugar validate

echo "Uploading..."
sugar upload

echo "Deploying..."
sugar deploy

echo "Verifying..."
sugar verify

# Mint the entire collection
# echo "Minting the entire collection..."
# TOTAL_NFTS=10  # Change this to match the number in your JSON configuration
# for ((i=1; i<=TOTAL_NFTS; i++))
# do
#   echo "Minting NFT $i of $TOTAL_NFTS..."
#   sugar mint
#   if [ $? -ne 0 ]; then
#     echo "Minting failed for NFT $i. Exiting."
#     exit 1
#   fi
# done

echo "Adding guard..."
sugar guard add

echo "Deployment and minting complete."

# Delete files after script finishes (success or failure)
echo "Cleaning up..."

# List of files to delete
FILES=("community_wallet.json" "deployer_wallet.json" "owner_wallet.json" "sugar.log")

# Delete each file if it exists
for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    rm -f "$file"
    echo "Deleted $file"
  else
    echo "$file not found."
  fi
done