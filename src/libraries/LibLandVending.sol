// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {TerminusFacet} from '../../lib/dao/contracts/terminus/TerminusFacet.sol';
import {IERC20} from '../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {LibERC721} from '../../lib/@lagunagames/cu-tokens/src/libraries/LibERC721.sol';
import {LibEvents} from '../libraries/LibEvents.sol';
import {LibLandDNA} from '../libraries/LibLandDNA.sol';
import {LibLandNames} from '../libraries/LibLandNames.sol';
import {LibResourceLocator} from '../../lib/@lagunagames/cu-common/src/libraries/LibResourceLocator.sol';
import {LibLand} from '../libraries/LibLand.sol';

/// @custom:storage-location erc7201:games.laguna.LibLandVending
library LibLandVending {
    bytes32 public constant LAND_VENDING_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256('games.laguna.LibLandVending')) - 1)) & ~bytes32(uint256(0xff));

    uint256 private constant decimals = 18;

    struct LandVendingStorage {
        mapping(uint8 => uint256) firstPhaseQuantityByLandType;
        mapping(uint8 => uint256) secondPhaseQuantityByLandType;
        mapping(uint8 => uint256) keystonePoolIdByLandType;
        mapping(uint8 => uint256) maxLandsByLandType;
        uint256 landVendingCommonRBWCost;
        uint256 landVendingUNIMCost;
        //minting
        mapping(uint8 => uint256) mintedLandsByLandType;
        // land vending machine start indexes by land type
        mapping(uint8 => uint256) landVendingStartingIndexesByLandType;
        // Begin and end prices for each land type and each phase
        mapping(uint8 => mapping(uint256 => uint256)) beginningByLandTypeAndPhase;
        mapping(uint8 => mapping(uint256 => uint256)) endByLandTypeAndPhase;
        // default token URI by land type
        mapping(uint8 => string) defaultTokenURIByLandType;
        uint256 landVendingRareRBWCost;
        uint256 landVendingMythicRBWCost;
    }

    function landVendingStorage() internal pure returns (LandVendingStorage storage lvs) {
        bytes32 position = LAND_VENDING_STORAGE_POSITION;
        assembly {
            lvs.slot := position
        }
    }

    function setMaxLandsByLandType(uint8 landType, uint256 max) internal {
        landVendingStorage().maxLandsByLandType[landType] = max;
    }

    function setFirstPhaseQuantityByLandType(uint8 landType, uint256 quantity) internal {
        landVendingStorage().firstPhaseQuantityByLandType[landType] = quantity;
    }

    function setSecondPhaseQuantityByLandType(uint8 landType, uint256 quantity) internal {
        landVendingStorage().secondPhaseQuantityByLandType[landType] = quantity;
    }

    function setBeginningByLandTypeAndPhase(uint8 landType, uint256 phase, uint256 beginning) internal {
        enforecePhaseIsValid(phase);
        enforceLandTypeIsValid(landType);
        landVendingStorage().beginningByLandTypeAndPhase[landType][phase] = beginning;
    }

    function setEndByLandTypeAndPhase(uint8 landType, uint256 phase, uint256 end) internal {
        enforecePhaseIsValid(phase);
        enforceLandTypeIsValid(landType);
        landVendingStorage().endByLandTypeAndPhase[landType][phase] = end;
    }

    function setCommonOwedRBW(uint256 amount) internal {
        landVendingStorage().landVendingCommonRBWCost = amount;
    }

    function setRareOwedRBW(uint256 amount) internal {
        landVendingStorage().landVendingRareRBWCost = amount;
    }

    function setMythicOwedRBW(uint256 amount) internal {
        landVendingStorage().landVendingMythicRBWCost = amount;
    }

    function setOwedUNIM(uint256 amount) internal {
        landVendingStorage().landVendingUNIMCost = amount;
    }

    function enforecePhaseIsValid(uint256 phase) internal pure {
        require(phase >= 1 && phase <= 3, 'LibLandVending: invalid phase.');
    }

    function getLandInventory() internal view returns (uint256[2][13] memory inventory) {
        LandVendingStorage storage lvs = landVendingStorage();
        for (uint8 i = 1; i <= 13; i++) {
            inventory[i - 1][0] = lvs.maxLandsByLandType[i] - lvs.mintedLandsByLandType[i];
            inventory[i - 1][1] = getCurrentPricingByLandType(i);
        }
        return inventory;
    }

    function getCurrentPricingByLandType(uint8 landType) internal view returns (uint256) {
        enforceLandTypeIsValid(landType);
        LandVendingStorage storage lvs = landVendingStorage();
        uint256 currentLandsByLandType = lvs.mintedLandsByLandType[landType];
        uint256 firstPhaseQuantity = lvs.firstPhaseQuantityByLandType[landType];
        uint256 secondPhaseQuantity = lvs.secondPhaseQuantityByLandType[landType];
        uint256 phase = 1;
        uint256 currentLandsOnCurrentPhase = currentLandsByLandType;
        uint256 phaseQuantity = firstPhaseQuantity;

        if (currentLandsByLandType >= secondPhaseQuantity) {
            phase = 3;
            currentLandsOnCurrentPhase = currentLandsByLandType - secondPhaseQuantity;
            phaseQuantity = lvs.maxLandsByLandType[landType] - secondPhaseQuantity;
        } else if (currentLandsByLandType >= firstPhaseQuantity) {
            phase = 2;
            currentLandsOnCurrentPhase = currentLandsByLandType - firstPhaseQuantity;
            phaseQuantity = secondPhaseQuantity - firstPhaseQuantity;
        }
        return getPriceForLandTypeAndPhase(landType, phase, currentLandsOnCurrentPhase, phaseQuantity);
    }

    function getPriceForLandTypeAndPhase(
        uint8 landType,
        uint256 phase,
        uint256 currentLandsOnCurrentPhase,
        uint256 phaseQuantity
    ) private view returns (uint256) {
        LandVendingStorage storage lvs = landVendingStorage();
        //Beginning is in wei
        uint256 beginning = lvs.beginningByLandTypeAndPhase[landType][phase];
        //End is in wei
        uint256 end = lvs.endByLandTypeAndPhase[landType][phase];
        //GrowthRate is in wei due to end and beginning being in wei
        uint256 growthRate = (end - beginning) / phaseQuantity;
        //Returned value is in wei
        return beginning + (growthRate * currentLandsOnCurrentPhase);
    }

    function beginKeystoneToLand(
        uint256 desiredPrice,
        uint8 landType,
        uint256 slippage
    ) internal returns (uint256 tokenId, string memory fullName) {
        enforceLandTypeIsValid(landType);
        LandVendingStorage storage lvs = landVendingStorage();
        TerminusFacet terminus = TerminusFacet(LibResourceLocator.unicornItems());
        uint256 keystonePool = lvs.keystonePoolIdByLandType[landType];

        require(terminus.balanceOf(msg.sender, keystonePool) > 0, 'LibLandVending: Player has no keystones left.');
        require(
            lvs.mintedLandsByLandType[landType] < lvs.maxLandsByLandType[landType],
            'LibLandVending: No lands left for the desired land type.'
        );
        uint256 marketPrice = getCurrentPricingByLandType(landType);
        require(
            desiredPrice + ((slippage * desiredPrice) / 100) >= marketPrice,
            'LibLandVending: slippage is higher than desired.'
        );

        IERC20(LibResourceLocator.rbwToken()).transferFrom(
            msg.sender,
            LibResourceLocator.gameBank(),
            getRBWCostByLandType(landType)
        );

        IERC20(LibResourceLocator.unimToken()).transferFrom(
            msg.sender,
            LibResourceLocator.gameBank(),
            lvs.landVendingUNIMCost
        );

        IERC20(LibResourceLocator.wethToken()).transferFrom(msg.sender, LibResourceLocator.gameBank(), marketPrice);

        terminus.burn(msg.sender, keystonePool, 1);
        tokenId = mintNextLandVendingToken(landType, msg.sender);
        fullName = LibLandNames._getFullNameString(tokenId);
        emit LibEvents.BeginLVMMinting(tokenId, fullName, landType);
        return (tokenId, fullName);
    }

    function batchFinishMinting(uint256[] calldata tokenIds, string[] calldata tokenURIs) internal {
        require(tokenIds.length == tokenURIs.length, 'LibLandVending: Array lengths must match.');
        for (uint256 i = 0; i < tokenIds.length; i++) {
            LibERC721.setTokenURI(tokenIds[i], tokenURIs[i]);
        }
    }

    function setKeystonePoolIdByLandType(uint8 landType, uint256 keystonePoolId) internal {
        landVendingStorage().keystonePoolIdByLandType[landType] = keystonePoolId;
    }

    function enforceLandTypeIsValid(uint8 landType) internal pure {
        require(landType > 0 && landType <= 13, 'LibLandVending: invalid land type.');
    }

    function setLandVendingStartingIndexByLandType(uint8 landType, uint256 startIndex) internal {
        landVendingStorage().landVendingStartingIndexesByLandType[landType] = startIndex;
    }

    function setDefaultTokenURIByLandType(uint8 landType, string memory tokenURI) internal {
        landVendingStorage().defaultTokenURIByLandType[landType] = tokenURI;
    }

    function getNextTokenIdByLandType(uint8 landType) private view returns (uint256) {
        LandVendingStorage storage lvs = landVendingStorage();
        return lvs.landVendingStartingIndexesByLandType[landType] + lvs.mintedLandsByLandType[landType];
    }

    function getMaxLandByLandType(uint8 landType) internal view returns (uint256) {
        return landVendingStorage().maxLandsByLandType[landType];
    }

    function getCurrentLandByLandType(uint8 landType) internal view returns (uint256) {
        return landVendingStorage().mintedLandsByLandType[landType];
    }

    function mintNextLandVendingToken(uint8 landType, address to) internal returns (uint256) {
        LandVendingStorage storage lvs = landVendingStorage();
        LibLand.LandStorage storage ds = LibLand.landStorage();

        require(
            lvs.landVendingStartingIndexesByLandType[landType] > 0,
            'LibLandVendingndsFacet: setLandVendingStartingIndexByLandType has not been called'
        );

        uint256 nextTokenId = lvs.landVendingStartingIndexesByLandType[landType] + lvs.mintedLandsByLandType[landType];

        //Update land type state
        ds.numMintedTokensByLandType[landType]++;
        lvs.mintedLandsByLandType[landType]++;

        LibERC721.mint(to, nextTokenId);

        //set dna
        uint256 dna = LibLandDNA._getDNA(nextTokenId);
        dna = LibLandDNA._setVersion(dna, LibLandDNA.DNA_VERSION);
        dna = LibLandDNA._setRarity(dna, getRarityByLandType(landType));
        dna = LibLandDNA._setLandType(dna, landType);
        dna = LibLandDNA._setLevel(dna, 1);

        uint256[3] memory nameIndexes = LibLandNames._getRandomName();
        dna = LibLandDNA._setFirstNameIndex(dna, nameIndexes[0]);
        dna = LibLandDNA._setMiddleNameIndex(dna, nameIndexes[1]);
        dna = LibLandDNA._setLastNameIndex(dna, nameIndexes[2]);
        LibLandDNA._setDNA(nextTokenId, dna);

        emit LibEvents.LandMinted(landType, nextTokenId, to);
        LibERC721.setTokenURI(nextTokenId, lvs.defaultTokenURIByLandType[landType]);
        return nextTokenId;
    }

    function getRarityByLandType(uint8 landType) internal pure returns (uint256) {
        if (landType == 1) {
            return LibLandDNA.RARITY_MYTHIC;
        } else if (landType <= 4) {
            return LibLandDNA.RARITY_RARE;
        } else {
            return LibLandDNA.RARITY_COMMON;
        }
    }

    function getRBWCostByLandType(uint8 landType) private view returns (uint256) {
        LandVendingStorage storage lvs = landVendingStorage();
        if (landType == 1) {
            return lvs.landVendingMythicRBWCost;
        } else if (landType <= 4) {
            return lvs.landVendingRareRBWCost;
        } else {
            return lvs.landVendingCommonRBWCost;
        }
    }

    function getCommonOwedRBW() internal view returns (uint256) {
        return landVendingStorage().landVendingCommonRBWCost;
    }

    function getRareOwedRBW() internal view returns (uint256) {
        return landVendingStorage().landVendingRareRBWCost;
    }

    function getMythicOwedRBW() internal view returns (uint256) {
        return landVendingStorage().landVendingMythicRBWCost;
    }

    function getOwedUNIM() internal view returns (uint256) {
        return landVendingStorage().landVendingUNIMCost;
    }

    function getLandVendingStartingIndexByLandType(uint8 landType) internal view returns (uint256) {
        return landVendingStorage().landVendingStartingIndexesByLandType[landType];
    }

    function getKeystonePoolIdByLandType(uint8 landType) internal view returns (uint256) {
        return landVendingStorage().keystonePoolIdByLandType[landType];
    }

    function getFirstPhaseQuantityByLandType(uint8 landType) internal view returns (uint256) {
        return landVendingStorage().firstPhaseQuantityByLandType[landType];
    }

    function getSecondPhaseQuantityByLandType(uint8 landType) internal view returns (uint256) {
        return landVendingStorage().secondPhaseQuantityByLandType[landType];
    }

    function getBeginningByLandTypeAndPhase(uint8 landType, uint256 phase) internal view returns (uint256) {
        return landVendingStorage().beginningByLandTypeAndPhase[landType][phase];
    }

    function getEndByLandTypeAndPhase(uint8 landType, uint256 phase) internal view returns (uint256) {
        return landVendingStorage().endByLandTypeAndPhase[landType][phase];
    }

    function getDefaultTokenURIByLandType(uint8 landType) internal view returns (string memory) {
        return landVendingStorage().defaultTokenURIByLandType[landType];
    }
}
