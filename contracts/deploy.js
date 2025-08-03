// Simple deployment script for Base L2
// This script can be used with Remix IDE or adapted for Hardhat/Foundry

// Configuration for different deployment environments
const DEPLOYMENT_CONFIGS = {
    testnet: {
        network: 'base-sepolia',
        chainId: 84532,
        rpcUrl: 'https://sepolia.base.org',
        explorerUrl: 'https://sepolia.basescan.org',
        
        // Contract addresses will be populated after deployment
        contracts: {
            LavaEscapeLives: '',
            LavaEscapeLeaderboard: ''
        },
        
        // Gas settings for Base Sepolia
        gasLimit: {
            LavaEscapeLives: 2000000,
            LavaEscapeLeaderboard: 2500000
        },
        
        gasPrice: '1000000000', // 1 gwei
        
        // BasePay settings
        basePay: {
            testnet: true,
            recipientAddress: '0x0000000000000000000000000000000000000000' // TODO: Update with deployer address
        }
    },
    
    mainnet: {
        network: 'base',
        chainId: 8453,
        rpcUrl: 'https://mainnet.base.org',
        explorerUrl: 'https://basescan.org',
        
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
        
        gasPrice: '1000000000', // 1 gwei - Base L2 is cheap!
        
        // BasePay settings
        basePay: {
            testnet: false,
            recipientAddress: '0x0000000000000000000000000000000000000000' // TODO: Update with deployer address
        }
    }
};

// Select deployment environment (change to 'mainnet' for production)
const DEPLOYMENT_ENVIRONMENT = process.env.DEPLOYMENT_ENV || 'testnet';
const DEPLOYMENT_CONFIG = DEPLOYMENT_CONFIGS[DEPLOYMENT_ENVIRONMENT];

// Dynamic deployment instructions based on environment
function getDeploymentInstructions() {
    const config = DEPLOYMENT_CONFIG;
    const isTestnet = DEPLOYMENT_ENVIRONMENT === 'testnet';
    
    return `
🚀 DEPLOYMENT INSTRUCTIONS FOR ${config.network.toUpperCase()}

📋 PHASE 1: GET TESTNET FUNDS (${isTestnet ? 'REQUIRED' : 'SKIP FOR MAINNET'})
${isTestnet ? `
1. Get Base Sepolia ETH:
   → https://www.alchemy.com/faucets/base-sepolia
   → Request funds for your deployer wallet

2. Get test USDC for BasePay testing:
   → https://faucet.circle.com/
   → Select Base Sepolia network
   → Get test USDC for payment testing
` : `
1. Bridge ETH to Base mainnet:
   → https://bridge.base.org/
   → Bridge sufficient ETH for deployment (~0.01 ETH recommended)
`}

📋 PHASE 2: DEPLOY CONTRACTS

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

5. Deploy to ${config.network}:
   - Connect MetaMask to ${config.network} network
   - Deploy LavaEscapeLives first
   - Deploy LavaEscapeLeaderboard second
   - Save contract addresses for step 6

6. Verify contracts on explorer:
   - Go to ${config.explorerUrl}
   - Find your contract
   - Click "Verify and Publish"
   - Use same compiler settings

📋 PHASE 3: UPDATE FRONTEND

7. Update contract addresses in index.html:
   - Replace CONTRACTS.LIVES with deployed LavaEscapeLives address
   - Replace CONTRACTS.LEADERBOARD with deployed LavaEscapeLeaderboard address
   - Update BasePay recipient address to deployer wallet

8. Update BasePay testnet setting:
   - Set testnet: ${config.basePay.testnet} in buyLivesWithBasePay function

🔗 ${config.network} Network Details:
- Network Name: ${config.network}
- RPC URL: ${config.rpcUrl}
- Chain ID: ${config.chainId}
- Currency: ETH
- Block Explorer: ${config.explorerUrl}

💰 Estimated Gas Costs:
- LavaEscapeLives: ~0.003 ETH
- LavaEscapeLeaderboard: ~0.004 ETH
- Total: ~0.007 ETH${isTestnet ? ' (FREE on testnet!)' : ' (~$20 USD on mainnet)'}

📋 PHASE 4: TESTING & DEPLOYMENT

9. Test all functions thoroughly:
   - Connect wallet and initialize player
   - Test ETH lives purchase (0.0001 ETH per life)
   - Test BasePay USDC purchase ($0.30 per life)
   - Test gameplay and lives consumption
   - Test leaderboard submission
   - Verify all transactions on ${config.explorerUrl}

10. ${isTestnet ? 'Deploy to mainnet after successful testing' : 'Deploy to production'}:
    ${isTestnet ? `- Run: DEPLOYMENT_ENV=mainnet node contracts/deploy.js
    - Repeat deployment process for mainnet
    - Update frontend for production` : `- Deploy updated frontend to Netlify
    - Register miniapp with Farcaster
    - Monitor contract interactions`}

📝 Post-Deployment Security:
1. Transfer ownership to multisig (recommended for mainnet)
2. Set up monitoring for contract events
3. Keep deployer private key secure
4. Consider emergency pause mechanisms

🎮 Ready to launch! Your Lava Escape miniapp is ${isTestnet ? 'ready for testing' : 'production-ready'}!
`;
}

const DEPLOYMENT_INSTRUCTIONS = getDeploymentInstructions();

console.log(DEPLOYMENT_INSTRUCTIONS);

// Export configuration for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        DEPLOYMENT_CONFIG,
        DEPLOYMENT_INSTRUCTIONS
    };
}