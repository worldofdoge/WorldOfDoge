// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract WODToken is ERC20, AccessControl{
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    constructor() ERC20("World Of Doge", "WOD"){
        _mint(
            0x49289DbD4f8C9aB6E37dA25d57650382fF87B97d,
            30000000 * 10**18
            ); // Seed Sale - 30.000.000 - 3%
        _mint(
            0xBd0Bb2534033A8d919d3f655cc2ca9849Aa8c2A1,
            130000000 * 10**18
            ); // Private Sale - 130.000.000 - 13%
        _mint(
            0x76170734D0d8b3E3eCDd2daDe04a4146a06c44cD,
            20000000 * 10**18
            ); // Public Sale - 20.000.000 - 2%
        _mint(
            0xa3e6496dC89b6c9d2E3d6476f0079d19279482a2,
            120000000 * 10**18
            ); // Marketing - 120.000.000 - 12%
        _mint(
            0x93685De6486eff47d5Db2AE4559cEc1b88D2f557,
            100000000 * 10**18
            ); // Liquidity - 100.000.000 - 10%
        _mint(
            0x90804Ec1557B44f819421a59C35Cb4506a27Da03,
            200000000 * 10**18
            ); // Team - 200.000.000 - 20%

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

