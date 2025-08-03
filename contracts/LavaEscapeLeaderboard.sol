// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title LavaEscapeLeaderboard
 * @dev Manages the global leaderboard for Lava Escape game
 * Tracks highest jump scores for each player and maintains a top 100 leaderboard
 */
contract LavaEscapeLeaderboard is Ownable, ReentrancyGuard {
    
    struct Score {
        address player;
        uint256 jumps;
        uint256 timestamp;
        uint256 level;
    }
    
    // Constants
    uint256 public constant MAX_LEADERBOARD_SIZE = 100;
    uint256 public constant MIN_SCORE_TO_SUBMIT = 5; // Minimum jumps to prevent spam
    
    // State variables
    mapping(address => uint256) public bestScores;
    mapping(address => uint256) public totalGamesPlayed;
    mapping(address => uint256) public totalJumps;
    
    Score[] public topScores;
    uint256 public totalGames;
    uint256 public totalPlayersEver;
    
    // Events
    event ScoreSubmitted(address indexed player, uint256 jumps, uint256 level, bool newPersonalBest, bool madeLeaderboard);
    event LeaderboardUpdated(address indexed player, uint256 jumps, uint256 position);
    
    constructor() Ownable(msg.sender) {
        // Initialize empty leaderboard
        // Owner is set to contract deployer
    }
    
    /**
     * @dev Submit a score to the leaderboard
     */
    function submitScore(uint256 jumps, uint256 level) external nonReentrant {
        require(jumps >= MIN_SCORE_TO_SUBMIT, "Score too low");
        require(level > 0, "Invalid level");
        
        address player = msg.sender;
        bool newPersonalBest = false;
        bool madeLeaderboard = false;
        
        // Track if this is a new player
        if (bestScores[player] == 0) {
            totalPlayersEver++;
        }
        
        // Update player stats
        totalGamesPlayed[player]++;
        totalJumps[player] += jumps;
        totalGames++;
        
        // Check if it's a personal best
        if (jumps > bestScores[player]) {
            bestScores[player] = jumps;
            newPersonalBest = true;
            
            // Try to add to leaderboard
            madeLeaderboard = _updateLeaderboard(player, jumps, level);
        }
        
        emit ScoreSubmitted(player, jumps, level, newPersonalBest, madeLeaderboard);
    }
    
    /**
     * @dev Internal function to update the leaderboard
     */
    function _updateLeaderboard(address player, uint256 jumps, uint256 level) internal returns (bool) {
        Score memory newScore = Score({
            player: player,
            jumps: jumps,
            timestamp: block.timestamp,
            level: level
        });
        
        // If leaderboard is not full, just add the score
        if (topScores.length < MAX_LEADERBOARD_SIZE) {
            topScores.push(newScore);
            _sortLeaderboard();
            emit LeaderboardUpdated(player, jumps, _findPlayerPosition(player));
            return true;
        }
        
        // Check if score is good enough for leaderboard
        if (jumps > topScores[MAX_LEADERBOARD_SIZE - 1].jumps) {
            // Replace the lowest score
            topScores[MAX_LEADERBOARD_SIZE - 1] = newScore;
            _sortLeaderboard();
            emit LeaderboardUpdated(player, jumps, _findPlayerPosition(player));
            return true;
        }
        
        return false;
    }
    
    /**
     * @dev Sort leaderboard in descending order (highest scores first)
     */
    function _sortLeaderboard() internal {
        if (topScores.length <= 1) return;
        
        // Simple bubble sort (efficient for small arrays)
        for (uint256 i = 0; i < topScores.length - 1; i++) {
            for (uint256 j = 0; j < topScores.length - i - 1; j++) {
                if (topScores[j].jumps < topScores[j + 1].jumps) {
                    // Swap
                    Score memory temp = topScores[j];
                    topScores[j] = topScores[j + 1];
                    topScores[j + 1] = temp;
                }
            }
        }
    }
    
    /**
     * @dev Find a player's position on the leaderboard (1-indexed, 0 if not on board)
     */
    function _findPlayerPosition(address player) internal view returns (uint256) {
        for (uint256 i = 0; i < topScores.length; i++) {
            if (topScores[i].player == player) {
                return i + 1; // 1-indexed position
            }
        }
        return 0; // Not on leaderboard
    }
    
    /**
     * @dev Get the full leaderboard
     */
    function getLeaderboard() external view returns (Score[] memory) {
        return topScores;
    }
    
    /**
     * @dev Get top N scores from the leaderboard
     */
    function getTopScores(uint256 n) external view returns (Score[] memory) {
        require(n > 0, "Invalid count");
        
        uint256 count = n > topScores.length ? topScores.length : n;
        Score[] memory result = new Score[](count);
        
        for (uint256 i = 0; i < count; i++) {
            result[i] = topScores[i];
        }
        
        return result;
    }
    
    /**
     * @dev Get a player's rank (1-indexed, 0 if not on leaderboard)
     */
    function getPlayerRank(address player) external view returns (uint256) {
        return _findPlayerPosition(player);
    }
    
    /**
     * @dev Get player statistics
     */
    function getPlayerStats(address player) external view returns (
        uint256 bestScore,
        uint256 gamesPlayed,
        uint256 totalJumpsEver,
        uint256 rank
    ) {
        return (
            bestScores[player],
            totalGamesPlayed[player],
            totalJumps[player],
            _findPlayerPosition(player)
        );
    }
    
    /**
     * @dev Get global game statistics
     */
    function getGlobalStats() external view returns (
        uint256 totalGamesEver,
        uint256 totalPlayersCount,
        uint256 leaderboardSize,
        uint256 highestScore
    ) {
        uint256 highest = 0;
        if (topScores.length > 0) {
            highest = topScores[0].jumps;
        }
        
        return (
            totalGames,
            totalPlayersEver,
            topScores.length,
            highest
        );
    }
    
    /**
     * @dev Check if a score would make it to the leaderboard
     */
    function wouldMakeLeaderboard(uint256 jumps) external view returns (bool) {
        if (topScores.length < MAX_LEADERBOARD_SIZE) {
            return jumps >= MIN_SCORE_TO_SUBMIT;
        }
        return jumps > topScores[MAX_LEADERBOARD_SIZE - 1].jumps;
    }
    
    /**
     * @dev Emergency function to clear leaderboard (owner only)
     */
    function clearLeaderboard() external onlyOwner {
        delete topScores;
    }
    
    /**
     * @dev Remove a specific player from leaderboard (owner only, for moderation)
     */
    function removePlayerFromLeaderboard(address player) external onlyOwner {
        for (uint256 i = 0; i < topScores.length; i++) {
            if (topScores[i].player == player) {
                // Move all elements after this one back by one position
                for (uint256 j = i; j < topScores.length - 1; j++) {
                    topScores[j] = topScores[j + 1];
                }
                topScores.pop();
                break;
            }
        }
    }
}