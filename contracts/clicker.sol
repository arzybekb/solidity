// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ClickerGameWithRewards
 * @dev Optimized clicker game: 1 click = 10 Tokens (Instant Mint)
 * No separate claim step. Cheaper gas. Better UX.
 */
contract ClickerGameWithRewards {
    // Token properties
    string public constant name = "ClickToken";
    string public constant symbol = "CLK";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    
    // Token reward rate: 1 click = 1 CLK token
    uint256 public constant TOKENS_PER_CLICK = 1 * 10**18;
    
    // Click tracking
    mapping(address => uint256) public userClicks;
    address[] public players;
    mapping(address => bool) public hasPlayed;
    
    // ERC20 balances and allowances
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    // Events
    event ClicksRecorded(address indexed user, uint256 totalClicks, uint256 addedClicks);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    /**
     * @dev Record clicks and MINT tokens immediately in one transaction
     * @param count Number of clicks to record (must be > 0)
     */
    function recordClicks(uint256 count) external {
        require(count > 0, "Count must be greater than 0");
        
        // 1. Record clicks
        userClicks[msg.sender] += count;
        
        // Register player if new
        if (!hasPlayed[msg.sender]) {
            hasPlayed[msg.sender] = true;
            players.push(msg.sender);
        }
        
        emit ClicksRecorded(msg.sender, userClicks[msg.sender], count);
        
        // 2. Mint tokens immediately
        uint256 tokensToMint = count * TOKENS_PER_CLICK;
        _mint(msg.sender, tokensToMint);
    }
    
    /**
     * @dev Get total clicks for a user
     */
    function getClicks(address user) external view returns (uint256) {
        return userClicks[user];
    }
    
    /**
     * @dev Get full leaderboard data
     * WARNING: This function returns arrays of all players. 
     * It is suitable for a demo/small scale, but not production with thousands of users due to gas limits.
     */
    function getLeaderboard() external view returns (address[] memory, uint256[] memory) {
        uint256 length = players.length;
        address[] memory allPlayers = new address[](length);
        uint256[] memory allScores = new uint256[](length);
        
        for (uint256 i = 0; i < length; i++) {
            allPlayers[i] = players[i];
            allScores[i] = userClicks[players[i]];
        }
        
        return (allPlayers, allScores);
    }
    
    // ========== ERC20 Functions ==========
    
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }
    
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }
    
    // ========== Internal Functions ==========
    
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Mint to zero address");
        
        totalSupply += amount;
        _balances[account] += amount;
        
        emit Transfer(address(0), account, amount);
    }
    
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        require(_balances[from] >= amount, "Insufficient balance");
        
        _balances[from] -= amount;
        _balances[to] += amount;
        
        emit Transfer(from, to, amount);
    }
    
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "Approve from zero address");
        require(spender != address(0), "Approve to zero address");
        
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "Insufficient allowance");
            _approve(owner, spender, currentAllowance - amount);
        }
    }
}
