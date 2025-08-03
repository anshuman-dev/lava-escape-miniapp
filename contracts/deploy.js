// Simple deployment script for Base L2
// This script can be used with Remix IDE or adapted for Hardhat/Foundry

const DEPLOYMENT_CONFIG = {
    network: 'base',
    chainId: 8453,
    rpcUrl: 'https://mainnet.base.org',
    
    // Contract addresses will be populated after deployment
    contracts: {
        LavaEscapeLives: '',
        LavaEscapeLeaderboard: ''
    },
    
    // Gas settings for Base L2
    gasLimit: {
        LavaEscapeLives: 2000000,
        LavaEscapeLeaderboard: 2500000
    },
    
    gasPrice: '1000000000' // 1 gwei - Base L2 is cheap!
};

// Deployment instructions for manual deployment via Remix:
const DEPLOYMENT_INSTRUCTIONS = `
🚀 DEPLOYMENT INSTRUCTIONS FOR BASE L2

1. Open Remix IDE (remix.ethereum.org)
2. Create new files and paste the contract code:
   - LavaEscapeLives.sol
   - LavaEscapeLeaderboard.sol

3. Install OpenZeppelin contracts:
   - In Remix File Explorer, create @openzeppelin folder
   - Add the required contracts or use GitHub import

4. Compile contracts:
   - Set Solidity version to 0.8.19+
   - Enable optimization (200 runs)

5. Deploy to Base L2:
   - Connect MetaMask to Base network
   - Deploy LavaEscapeLives first
   - Deploy LavaEscapeLeaderboard second
   - Save contract addresses

6. Verify contracts on BaseScan:
   - Go to basescan.org
   - Find your contract
   - Click "Verify and Publish"
   - Use same compiler settings

7. Update frontend:
   - Replace placeholder addresses in index.html
   - Update CONTRACTS object with real addresses

🔗 Base L2 Network Details:
- Network Name: Base
- RPC URL: https://mainnet.base.org
- Chain ID: 8453
- Currency: ETH
- Block Explorer: https://basescan.org

💰 Estimated Gas Costs:
- LavaEscapeLives: ~0.003 ETH
- LavaEscapeLeaderboard: ~0.004 ETH
- Total: ~0.007 ETH (~$20 USD)

📝 Post-Deployment Steps:
1. Set game contract address in LavaEscapeLives (if needed)
2. Transfer ownership to multisig (recommended)
3. Test all functions with small amounts
4. Update frontend with contract addresses
5. Deploy to production
`;

console.log(DEPLOYMENT_INSTRUCTIONS);

// Export configuration for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        DEPLOYMENT_CONFIG,
        DEPLOYMENT_INSTRUCTIONS
    };
}