require('dotenv').config();
const bs58 = require('bs58').default;
const fs = require('fs');

// Function to decode Base58 and save as JSON
function saveWallet(key, fileName) {
  try {
    const decoded = bs58.decode(key);
    const walletArray = Array.from(decoded);
    fs.writeFileSync(fileName, JSON.stringify(walletArray, null, 2));
    console.log(`✅ ${fileName} created successfully`);
  } catch (error) {
    console.error(`❌ Error creating ${fileName}: ${error.message}`);
  }
}

// Read keys from environment variables
const deployerKey = process.env.DEPLOYER_PK;
const ownerKey = process.env.OWNER_PK;
const communityKey = process.env.COMMUNITY_PK;

// Validate that all keys exist
if (!deployerKey || !ownerKey || !communityKey) {
  console.error('❌ Missing one or more private keys in .env file');
  process.exit(1);
}

// Save wallets
saveWallet(deployerKey, 'deployer_wallet.json');
saveWallet(ownerKey, 'owner_wallet.json');
saveWallet(communityKey, 'community_wallet.json');
