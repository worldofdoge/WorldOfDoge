// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
interface IDogeHero is IERC721Enumerable {
    /**
    event Birth sẽ được tạo khi doge mới được sinh ra
    backend sẽ listen event này để tạo ra hình ảnh phù hợp với bộ genes
     */
    event Birth(address owner, uint256 dogeId, uint256 matronId, uint256 sireId, uint256 genes);

    /** event Pregnant sẽ được tạo khi doge được phối giống thành công (mang thai)
     */
    event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);
    /// @notice Grants approval to another user to sire with one of your Doges.
    /// @param _addr The address that will be able to sire with your Doge. Set to
    ///  address(0) to clear all siring approvals for this Doge.
    /// @param _sireId A Doge that you own that _addr will now be able to sire with.
    function approveSiring(address _addr, uint256 _sireId) external;

    /// @notice Checks that a given doge is able to breed (i.e. it is not pregnant or
    ///  in the middle of a siring cooldown).
    /// @param _dogeId reference the id of the doge, any user can inquire about it
    function isReadyToBreed(uint256 _dogeId) external view returns (bool);

    /// @dev Checks whether a doge is currently pregnant.
    /// @param _dogeId reference the id of the doge, any user can inquire about it
    function isPregnant(uint256 _dogeId) external view returns (bool);

    /// @notice Checks to see if two doges can breed together, including checks for
    ///  ownership and siring approvals. Does NOT check that both doges are ready for
    ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
    ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
    /// @param _matronId The ID of the proposed matron.
    /// @param _sireId The ID of the proposed sire.
    function canBreedWith(uint256 _matronId, uint256 _sireId) external view returns(bool);

    /// @notice Breed a Doge you own (as matron) with a sire that you own, or for which you
    ///  have previously been given Siring approval. Will either make your doge pregnant, or will
    ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
    /// @param _matronId The ID of the Doge acting as matron (will end up pregnant if successful)
    /// @param _sireId The ID of the Doge acting as sire (will begin its siring cooldown if successful)
    function breedWithAuto(uint256 _matronId, uint256 _sireId) external payable;

    /// @notice Have a pregnant Doge give birth!
    /// @param _matronId A Doge ready to give birth.
    /// @return The Doge ID of the new doge.
    /// @dev Looks at a given Doge and, if pregnant and if the gestation period has passed,
    ///  combines the genes of the two parents to create a new doge. The new Doge is assigned
    ///  to the current owner of the matron. Upon successful completion, both the matron and the
    ///  new doge will be ready to breed again. Note that anyone can call this function (if they
    ///  are willing to pay the gas!), but the new doge always goes to the mother's owner.
    function giveBirth(uint256 _matronId) external returns(uint256);

    /// @dev Put a doge up for auction.
    function createSaleAuction(
        uint256 _dogeId, 
        uint256 _startingPrice, 
        uint256 _endingPrice, 
        uint256 _duration) external;

    /// @dev Put a doge up for auction to be sire.
    ///  Performs checks to ensure the doge can be sired, then
    ///  delegates to reverse auction.
    function createSiringAuction(
        uint256 _dogeId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration) external;

    /// @dev Completes a siring auction by bidding.
    ///  Immediately breeds the winning matron with the sire on auction.
    /// @param _sireId - ID of the sire on auction.
    /// @param _matronId - ID of the matron owned by the bidder.
    function bidOnSiringAuction(
        uint256 _sireId,
        uint256 _matronId
    ) external payable;

    /// @notice Returns all the relevant information about a specific doge.
    /// @param _id The ID of the doge of interest.
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
    function rubyFees(uint256 index) external view returns(uint256);
    function wodFees(uint256 index) external view returns(uint256);
    function cooldowns(uint256 index) external view returns(uint32);
    function autoBirthFee() external view returns(uint256);
    //số doge đang mang thai
    function pregnantDoges() external view returns(uint256);
}

interface IDogeWar {
    event DepositDoges(address indexed owner, uint256[] dogeIds);
    event WithdrawDoges(address indexed owner, uint256[] dogeIds);
    /**
    status = 0: hòa
    status = 1: win
    status = 2: lose
     */
    event CreateHero(address indexed heroOwner, uint256 heroId);
    event RetireHero(address indexed heroOwner, uint256 heroId);
    event AttackHero(address indexed attacker, address indexed defender, uint256 status, uint256 reward);
    
    function depositDoges(uint256[] memory dogeIds) external;
    function withdrawDoges(uint256[] memory dogeIds) external;
    function withdrawAllDoges() external;
    function attackHero(address defenderAddress) external;
    function harvestReward() external;
    function pendingReward() external view returns(uint256 pendingRuby, uint256 pendingWOD);
    function areInPointsRange(address _attacker, address _defender) external view returns (bool);
    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 dogeId) external view returns (address);
    function getDoges(address owner) external view returns(uint256[] memory);
    function getTotalHeroOwner() external view returns(uint256);
    function allHeroOwners(uint256 index) external view returns(address);
    function getHeroOwners() external view returns(address[] memory);
    function heroInfo(address owner) 
        external 
        view 
        returns(
            uint32 rank,
            uint32 share,
            uint32 health,
            uint32 attack,
            uint32 defense,
            uint176 rubyDebt,
            uint176 wodDebt
        );
    function getDogeStat(uint256 dogeId) 
        external 
        view 
        returns(
            uint256 share, 
            uint256 health, 
            uint256 attack, 
            uint256 defense);
    function totalShare() external view returns(uint256);
    
}

interface IGeneScience {
    /// @dev return the expressing traits
    /// @param _genes the long number expressing cat genes
    function expressingTraits(uint256 _genes) external pure returns(uint256[12] memory);    
}

interface ISaleClockAuction {
    // event AuctionCreated được tạo khi đăng bán
    event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
    
    // event AuctionSuccessful được tạo khi mua doge thành công
    event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);

    //event AuctionCancelled được tạo khi hủy bán
    event AuctionCancelled(uint256 tokenId);

    /// @dev Cancels an auction that hasn't been won yet.
    ///  Returns the NFT to original owner.
    /// @notice This is a state-modifying function that can
    ///  be called while the contract is paused.
    /// @param _tokenId - ID of token on auction
    function cancelAuction(uint256 _tokenId) external;

    /// @dev Returns auction info for an NFT on auction.
    /// @param _tokenId - ID of NFT on auction.
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

    /// @dev Returns the current price of an auction.
    /// @param _tokenId - ID of the token price we are checking.
    function getCurrentPrice(uint256 _tokenId) external view returns (uint256);

    /// @dev buy a Doge
    /// @param _tokenId - ID of NFT on auction.
    function bid(uint256 _tokenId) external payable;

    /**
    @dev Return the number of dogs for sale
    @param owner - Owner of dogs for sale
     */
    function balanceOf(address owner) external view returns (uint256);

    /**
    @dev Return the owner of a doge
    @param tokenId - doge Id
     */
    function ownerOf(uint256 tokenId) external view returns (address);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    /** phí giao dịch doge
     có giá trị từ 0-10,000 tương ứng với 0%-100% (hiện tại giá trị này bằng 500 tương đương 5%)
     */
    function ownerCut() external view returns(uint256);
}

interface ISiringClockAuction {
    //các event bên dưới tương tự như contract ISaleClockAuction
    event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
    event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
    event AuctionCancelled(uint256 tokenId);

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
    /** phí giao dịch doge
     có giá trị từ 0-10,000 tương ứng với 0%-100% (hiện tại giá trị này bằng 500 tương đương 5%)
     */
    function ownerCut() external view returns(uint256);
}
interface IWODToken is IERC20 {}
interface IRubyToken is IERC20 {}