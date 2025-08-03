// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title LavaEscapeLives
 * @dev Manages lives for the Lava Escape game on Base L2
 * Players start with 3 lives and can purchase more with ETH or USDC
 */
contract LavaEscapeLives is Ownable, ReentrancyGuard {
    
    // Constants
    uint8 public constant DEFAULT_LIVES = 3;
    uint8 public constant MAX_LIVES = 255;
    uint256 public constant LIFE_PRICE_ETH = 0.0001 ether; // ~$0.30 USD
    uint256 public constant LIFE_PRICE_USDC = 300000; // 0.3 USDC (6 decimals)
    
    // Base USDC contract address
    IERC20 public constant USDC = IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
    
    // State variables
    mapping(address => uint8) public lives;
    mapping(address => bool) public hasPlayedBefore;
    address public gameContract;
    
    // Events
    event LivesPurchased(address indexed player, uint8 amount, bool paidWithUSDC);
    event LivesUsed(address indexed player, uint8 remainingLives);
    event LivesGranted(address indexed player, uint8 amount);
    event FundsWithdrawn(address indexed owner, uint256 ethAmount, uint256 usdcAmount);
    
    constructor() {
        // Owner can be set to a multisig later
    }
    
    /**
     * @dev Initialize a new player with default lives
     */
    function initializePlayer(address player) external {
        require(player != address(0), "Invalid player address");
        
        if (!hasPlayedBefore[player]) {
            lives[player] = DEFAULT_LIVES;
            hasPlayedBefore[player] = true;
        }
    }
    
    /**
     * @dev Buy lives with ETH
     */
    function buyLives(uint8 amount) external payable nonReentrant {
        require(amount > 0 && amount <= 10, "Invalid amount (1-10)");
        require(msg.value == LIFE_PRICE_ETH * amount, "Incorrect ETH amount");
        require(lives[msg.sender] + amount <= MAX_LIVES, "Would exceed max lives");
        
        // Initialize player if first time
        if (!hasPlayedBefore[msg.sender]) {
            lives[msg.sender] = DEFAULT_LIVES;
            hasPlayedBefore[msg.sender] = true;
        }
        
        lives[msg.sender] += amount;
        
        emit LivesPurchased(msg.sender, amount, false);
    }
    
    /**
     * @dev Buy lives with USDC
     */
    function buyLivesWithUSDC(uint8 amount) external nonReentrant {
        require(amount > 0 && amount <= 10, "Invalid amount (1-10)");
        require(lives[msg.sender] + amount <= MAX_LIVES, "Would exceed max lives");
        
        uint256 totalCost = LIFE_PRICE_USDC * amount;
        
        // Initialize player if first time
        if (!hasPlayedBefore[msg.sender]) {
            lives[msg.sender] = DEFAULT_LIVES;
            hasPlayedBefore[msg.sender] = true;
        }
        
        // Transfer USDC from player
        require(USDC.transferFrom(msg.sender, address(this), totalCost), "USDC transfer failed");
        
        lives[msg.sender] += amount;
        
        emit LivesPurchased(msg.sender, amount, true);
    }
    
    /**
     * @dev Use a life (called by game contract or authorized address)
     */
    function useLive(address player) external {
        require(msg.sender == gameContract || msg.sender == owner(), "Not authorized");
        require(lives[player] > 0, "No lives remaining");
        
        lives[player]--;
        
        emit LivesUsed(player, lives[player]);
    }
    
    /**
     * @dev Grant free lives to a player (owner only)
     */
    function grantLives(address player, uint8 amount) external onlyOwner {
        require(player != address(0), "Invalid player address");
        require(amount > 0, "Amount must be positive");
        require(lives[player] + amount <= MAX_LIVES, "Would exceed max lives");
        
        if (!hasPlayedBefore[player]) {
            lives[player] = DEFAULT_LIVES;
            hasPlayedBefore[player] = true;
        }
        
        lives[player] += amount;
        
        emit LivesGranted(player, amount);
    }
    
    /**
     * @dev Set the game contract address (owner only)
     */
    function setGameContract(address _gameContract) external onlyOwner {
        gameContract = _gameContract;
    }
    
    /**
     * @dev Get lives for a player
     */
    function getLives(address player) external view returns (uint8) {
        if (!hasPlayedBefore[player]) {
            return DEFAULT_LIVES;
        }
        return lives[player];
    }
    
    /**
     * @dev Check if player can start a game
     */
    function canPlay(address player) external view returns (bool) {
        if (!hasPlayedBefore[player]) {
            return true; // New players get default lives
        }
        return lives[player] > 0;
    }
    
    /**
     * @dev Withdraw contract funds (owner only)
     */
    function withdraw() external onlyOwner nonReentrant {
        uint256 ethBalance = address(this).balance;
        uint256 usdcBalance = USDC.balanceOf(address(this));
        
        if (ethBalance > 0) {
            (bool success, ) = payable(owner()).call{value: ethBalance}("");
            require(success, "ETH withdrawal failed");
        }
        
        if (usdcBalance > 0) {
            require(USDC.transfer(owner(), usdcBalance), "USDC withdrawal failed");
        }
        
        emit FundsWithdrawn(owner(), ethBalance, usdcBalance);
    }
    
    /**
     * @dev Emergency function to pause the contract
     */
    function emergencyPause() external onlyOwner {
        // In a production version, this would implement Pausable functionality
        // For now, we can change the game contract to address(0) to pause
        gameContract = address(0);
    }
}