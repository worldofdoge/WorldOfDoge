// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
interface IDogeHero is IERC721Enumerable {
    function approveSiring(address _addr, uint256 _sireId) external;
    function isReadyToBreed(uint256 _dogeId) external view returns (bool);
    function isPregnant(uint256 _dogeId) external view returns (bool);
    function canBreedWith(uint256 _matronId, uint256 _sireId) external view returns(bool);
    function breedWithAuto(uint256 _matronId, uint256 _sireId) external payable;
    function giveBirth(uint256 _matronId) external returns(uint256);
    function createSaleAuction(
        uint256 _dogeId, 
        uint256 _startingPrice, 
        uint256 _endingPrice, 
        uint256 _duration) external;
    function createSiringAuction(
        uint256 _dogeId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration) external;
    function bidOnSiringAuction(
        uint256 _sireId,
        uint256 _matronId
    ) external payable;
    function getDoge(uint256 _id)
        external
        view
        returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );


}

interface IDogeWar {
    function heroEnter(uint256[] memory heroIds) external;
    function heroLeave(uint256 amount) external;
    function heroLeave2(uint256[] memory heroIds) external;
    function leaveAll() external;
    function attackDoge(address defenderAddress) external;
    function harvestReward() external;
    function pendingReward() external view returns(uint256 pendingRuby, uint256 pendingWOD);
    function areInPointsRange(address _attacker, address _defender) external view returns (bool);
    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    function getTotalHeroOwner() external view returns(uint256);
}

interface IGeneScience {
    function expressingTraits(uint256 _genes) external pure returns(uint8[12] memory);    
}

interface ISaleClockAuction {
    function cancelAuction(uint256 _tokenId) external;
    function getAuction(uint256 _tokenId)
        external
        view
        returns
    (
        address seller,
        uint256 startingPrice,
        uint256 endingPrice,
        uint256 duration,
        uint256 startedAt
    );
    function getCurrentPrice(uint256 _tokenId) external view returns (uint256);
    function bid(uint256 _tokenId) external payable;
    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}

interface ISiringClockAuction {
    function cancelAuction(uint256 _tokenId) external;
    function getAuction(uint256 _tokenId)
        external
        view
        returns
    (
        address seller,
        uint256 startingPrice,
        uint256 endingPrice,
        uint256 duration,
        uint256 startedAt
    );
    function getCurrentPrice(uint256 _tokenId) external view returns (uint256);
    function bid(uint256 _tokenId) external payable;
    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}
interface IWODToken is IERC20 {}
interface IRubyToken is IERC20 {}