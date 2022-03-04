// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract WODToken is ERC20, AccessControl{
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    constructor() ERC20("World Of Doge", "WOD"){               
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    function mint(address account, uint amount) external onlyRole(MINTER_ROLE) {
        require(totalSupply() + amount <= MAX_SUPPLY);
        _mint(account, amount);
    }
    function burn(address account, uint amount) external onlyRole(BURNER_ROLE) {
        _burn(account, amount);
    }
}

