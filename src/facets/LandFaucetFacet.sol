// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ITestnetDebugRegistry} from "../../lib/cu-osc-common/src/interfaces/ITestnetDebugRegistry.sol";
import {LibLandNames} from "../libraries/LibLandNames.sol";
import {LibLandVending} from "../libraries/LibLandVending.sol";
import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibLandDNA} from "../libraries/LibLandDNA.sol";
import {LibLandFaucet} from "../libraries/LibLandFaucet.sol";
import {LibResourceLocator} from "../../lib/cu-osc-common/src/libraries/LibResourceLocator.sol";
import {LibLand} from "../libraries/LibLand.sol";
import {LibEvents} from "../libraries/LibEvents.sol";
import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";

contract LandFaucetFacet {
    function faucetMintLand(address to, uint8 landType) public {
        ITestnetDebugRegistry(LibResourceLocator.testnetDebugRegistry())
            .enforceDebugger(msg.sender);
        LibLandVending.enforceLandTypeIsValid(landType);
        uint256 nextTokenId = LibLandFaucet.getNextTokenId();
        LibLand.landStorage().numMintedTokensByLandType[landType]++;
        LibERC721.mint(to, nextTokenId);

        //set dna
        uint256 dna = LibLandDNA._getDNA(nextTokenId);
        dna = LibLandDNA._setVersion(dna, LibLandDNA.DNA_VERSION);
        dna = LibLandDNA._setRarity(
            dna,
            LibLandVending.getRarityByLandType(landType)
        );
        dna = LibLandDNA._setLandType(dna, landType);
        dna = LibLandDNA._setLevel(dna, 1);

        uint256[3] memory nameIndexes = LibLandNames._getRandomName();
        dna = LibLandDNA._setFirstNameIndex(dna, nameIndexes[0]);
        dna = LibLandDNA._setMiddleNameIndex(dna, nameIndexes[1]);
        dna = LibLandDNA._setLastNameIndex(dna, nameIndexes[2]);
        LibLandDNA._setDNA(nextTokenId, dna);

        LibERC721.setTokenURI(
            nextTokenId,
            LibLandVending.landVendingStorage().defaultTokenURIByLandType[
                landType
            ]
        );
        emit LibEvents.BeginLVMMinting(
            nextTokenId,
            LibLandNames._getFullName(nextTokenId),
            landType
        );
    }

    function faucetBatchMintLand(
        address to,
        uint8 landType,
        uint256 amount
    ) external {
        ITestnetDebugRegistry(LibResourceLocator.testnetDebugRegistry())
            .enforceDebugger(msg.sender);
        LibLandVending.enforceLandTypeIsValid(landType);
        for (uint256 i = 0; i < amount; i++) {
            faucetMintLand(to, landType);
        }
    }

    function faucetBurnLand(uint256 tokenId) external {
        ITestnetDebugRegistry(LibResourceLocator.testnetDebugRegistry())
            .enforceDebugger(msg.sender);
        LibERC721.burn(tokenId);
    }
}
