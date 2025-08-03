# 🌋 Lava Escape - Onchain Farcaster Mini App

A web-based endless jumping game where players control a stickman character trying to escape rising lava by jumping between platforms. Now with **onchain lives system** and **global leaderboard** on Base L2!

## 🎮 Game Features

- **Endless vertical scrolling gameplay** - Jump between platforms as lava rises
- **Progressive difficulty** - Lava speed increases every 15 jumps
- **Onchain lives system** - Start with 3 lives, purchase more with ETH or USDC
- **Global leaderboard** - Compete with other players on Base L2
- **Farcaster integration** - Social sharing and mini-app functionality
- **Mobile-friendly controls** - Keyboard, touch, and click support

## ⛓️ Onchain Features

### Lives System
- Players start with 3 lives
- Lose a life when caught by lava or falling off platforms
- Purchase additional lives with ETH (0.001 ETH per life) or USDC (3 USDC per life)
- Lives are stored onchain on Base L2

### Leaderboard
- Submit high scores to global leaderboard
- Minimum 5 jumps required to prevent spam
- Track best scores, total games played, and rankings
- View top 100 players globally

## 🚀 Technology Stack

- **Frontend**: Pure HTML5, CSS3, JavaScript (no frameworks)
- **Graphics**: HTML5 Canvas for game rendering
- **Blockchain**: Base L2 (Chain ID: 8453)
- **Smart Contracts**: Solidity 0.8.19+ with OpenZeppelin
- **Wallet Integration**: Wagmi + Viem
- **Social Integration**: Farcaster MiniApp SDK
- **Hosting**: Netlify

## 📦 Project Structure

```
lava-escape-miniapp/
├── index.html              # Main game file
├── package.json            # Node.js dependencies
├── .well-known/
│   └── farcaster.json     # Farcaster manifest
├── contracts/
│   ├── LavaEscapeLives.sol        # Lives management contract
│   ├── LavaEscapeLeaderboard.sol  # Leaderboard contract
│   └── deploy.js                  # Deployment instructions
├── icon.png               # Game icon (200x200px)
├── splash.png            # Splash screen (200x200px)
└── README.md             # This file
```

## 🛠️ Development Setup

### Prerequisites
- Node.js 22.11.0 or higher
- MetaMask or compatible wallet
- Base L2 network added to wallet

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd lava-escape-miniapp

# Install dependencies
npm install

# Start development server
npm run dev
```

### Testing Locally
1. Open http://localhost:3000
2. Add `?debug=true` to see debug information
3. Test all features including wallet integration

## 🚀 Deployment Guide

### Phase 1: Deploy Smart Contracts

1. **Open Remix IDE** (remix.ethereum.org)
2. **Upload contracts**:
   - Copy `contracts/LavaEscapeLives.sol`
   - Copy `contracts/LavaEscapeLeaderboard.sol`
3. **Install dependencies**:
   - Add OpenZeppelin contracts via GitHub import
4. **Compile with**:
   - Solidity version: 0.8.19+
   - Optimization: 200 runs
5. **Deploy to Base L2**:
   - Connect MetaMask to Base network
   - Deploy LavaEscapeLives first
   - Deploy LavaEscapeLeaderboard second
   - **Save contract addresses!**

### Phase 2: Update Frontend

1. **Update contract addresses** in `index.html`:
   ```javascript
   const CONTRACTS = {
       LIVES: '0xYOUR_LIVES_CONTRACT_ADDRESS',
       LEADERBOARD: '0xYOUR_LEADERBOARD_CONTRACT_ADDRESS',
       // ...
   };
   ```

2. **Update Farcaster manifest** in `.well-known/farcaster.json`:
   - Generate proper signature for your domain
   - Use `generate-signature.js` script for guidance

### Phase 3: Deploy to Production

1. **Deploy to Netlify**:
   ```bash
   npm run deploy
   ```

2. **Verify contracts** on BaseScan:
   - Visit basescan.org
   - Verify each contract with same compiler settings

3. **Test thoroughly**:
   - Test all game mechanics
   - Verify wallet connections
   - Test lives purchasing
   - Test leaderboard submissions

## 💰 Cost Estimates

### Smart Contract Deployment
- LavaEscapeLives: ~0.003 ETH
- LavaEscapeLeaderboard: ~0.004 ETH
- **Total**: ~0.007 ETH (~$20 USD)

### Gameplay Costs
- Buy 1 life: 0.001 ETH (~$3 USD)
- Submit score: ~0.0001 ETH (~$0.30 USD)
- All interactions are very affordable on Base L2!

## 🔧 Configuration

### Environment Variables
```bash
# Optional: Set in your deployment environment
FARCASTER_FID=your_fid_here
WALLET_ADDRESS=your_wallet_address
```

### Game Settings
Modify these constants in `index.html`:
```javascript
// Lives pricing
LIFE_PRICE_ETH = 0.001 ether
LIFE_PRICE_USDC = 3000000 // 3 USDC

// Game mechanics
DEFAULT_LIVES = 3
MIN_SCORE_TO_SUBMIT = 5
MAX_LEADERBOARD_SIZE = 100
```

## 🔍 Debug Mode

Add `?debug=true` to the URL to see:
- SDK initialization status
- Wallet connection status
- Transaction details
- Error messages

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - feel free to use this code for your own projects!

## 🆘 Support

- Check the debug console for error messages
- Verify wallet is connected to Base L2
- Ensure contracts are deployed and addresses are correct
- Test with small amounts first

## 🎯 Roadmap

- [ ] Add USDC payment integration
- [ ] Implement power-ups and special abilities
- [ ] Add tournament mode
- [ ] Create NFT rewards for top players
- [ ] Add more visual effects and animations

---

Built with ❤️ for the Farcaster ecosystem on Base L2