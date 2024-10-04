// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {CutERC721Diamond} from "../../lib/cu-osc-common-tokens/src/implementation/CutERC721Diamond.sol";

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract LandImplementation is CutERC721Diamond {
    event DNAUpdated(uint256 tokenId, uint256 dna);
    event LandLockedIntoGame(uint256 tokenId, address locker);
    event LandLockedIntoGameV2(
        uint256 indexed tokenId,
        address indexed owner,
        address locker
    );
    event LandUnlockedOutOfGame(uint256 tokenId, address locker);
    event LandUnlockedOutOfGameV2(
        uint256 indexed tokenId,
        address indexed owner,
        address locker
    );
    event LandUnlockedOutOfGameForcefully(uint256 tokenId, address locker);
    event LandMinted(uint8 indexed landType, uint256 tokenId, address owner);
    event BeginLVMMinting(
        uint256 indexed tokenId,
        string indexed fullName,
        uint256 indexed landType
    );

    function lockLandIntoGame(uint256 tokenId) external {}
    function unlockLandOutOfGameGenerateMessageHash(
        uint256 tokenId,
        string memory tokenURI,
        uint256 _level,
        uint256 requestId,
        uint256 blockDeadline
    ) public view returns (bytes32) {}
    function unlockLandOutOfGameWithSignature(
        uint256 tokenId,
        string calldata tokenURI,
        uint256 _level,
        uint256 requestId,
        uint256 blockDeadline,
        bytes memory signature
    ) public {}
    function landIsTransferrable(uint256 tokenId) public view returns (bool) {}
    function paymentToken() external view returns (address) {}
    function getLandTypeByTokenId(
        uint256 tokenId
    ) external view returns (uint8) {}
    function changeContractURI(string memory _contractURI) public {}
    function changeLicenseURI(string memory _licenseURI) public {}
    function getNumMintedTokensByLandType()
        external
        view
        returns (
            uint256 mythic,
            uint256 rareLight,
            uint256 rareWonder,
            uint256 rareMystery,
            uint256 commonHeart,
            uint256 commonCloud,
            uint256 commonFlower,
            uint256 commonCandy,
            uint256 commonCrystal,
            uint256 commonMoon
        )
    {}
    function getLandInventory() external view returns (uint256[2][13] memory) {}
    function beginKeystoneToLand(
        uint256 price,
        uint8 landType,
        uint256 slippage
    ) external returns (uint256, string memory) {}
    function batchFinishMinting(
        uint256[] calldata tokenIds,
        string[] calldata tokenURIs
    ) external {}
    function getMaxLandByLandType(
        uint8 landType
    ) external view returns (uint256) {}
    function getCommonOwedRBW() external view returns (uint256) {}
    function getRareOwedRBW() external view returns (uint256) {}
    function getMythicOwedRBW() external view returns (uint256) {}
    function getOwedUNIM() external view returns (uint256) {}
    function getLandVendingStartingIndexByLandType(
        uint8 landType
    ) external view returns (uint256) {}
    function getKeystonePoolIdByLandType(
        uint8 landType
    ) external view returns (uint256) {}

    function getFirstPhaseQuantityByLandType(
        uint8 landType
    ) external view returns (uint256) {}

    function getSecondPhaseQuantityByLandType(
        uint8 landType
    ) external view returns (uint256) {}

    function getBeginningByLandTypeAndPhase(
        uint8 landType,
        uint256 phase
    ) external view returns (uint256) {}

    function getEndByLandTypeAndPhase(
        uint8 landType,
        uint256 phase
    ) external view returns (uint256) {}

    function getCurrentLandByLandType(
        uint8 landType
    ) external view returns (uint256) {}

    function getDefaultTokenURIByLandType(
        uint8 landType
    ) external view returns (string memory) {}
    function getLandMetaData(
        uint256 _tokenId
    )
        external
        view
        returns (
            string memory tokenURI,
            uint8 origin,
            bool gameLocked,
            bool limitedEdition,
            uint8 rarity,
            uint16 landType,
            uint8 class,
            uint8 classGroup,
            uint8 level,
            string memory fullName,
            bool mythic
        )
    {}
    function getAllLandIdsForOwner(
        address _owner
    ) external view returns (uint256[] memory) {}
    function getLandsByOwner(
        address _owner,
        uint32 _pageNumber
    )
        external
        view
        returns (
            uint256[] memory tokenIds,
            uint16[] memory landTypes,
            string[] memory names,
            bool[] memory gameLocked,
            bool moreEntriesExist
        )
    {}
    function lookupFirstName(
        uint256 _nameId
    ) external view returns (string memory) {}

    function lookupMiddleName(
        uint256 _nameId
    ) external view returns (string memory) {}

    function lookupLastName(
        uint256 _nameId
    ) external view returns (string memory) {}

    function getFullName(
        uint256 _tokenId
    ) external view returns (string memory) {}

    function getFullNameFromDNA(
        uint256 _dna
    ) public view returns (string memory) {}
}
