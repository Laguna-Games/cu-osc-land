// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol";

import {LibDiamond} from "../../lib/cu-osc-diamond-template/src/libraries/LibDiamond.sol";
import {LibLandDNA} from "../libraries/LibLandDNA.sol";
import {LibServerSideSigning} from "../../lib/cu-osc-common/src/libraries/LibServerSideSigning.sol";
import {LibEvents} from "../libraries/LibEvents.sol";
import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibResourceLocator} from "../../lib/cu-osc-common/src/libraries/LibResourceLocator.sol";
import {LibPermissions} from "../libraries/LibPermissions.sol";
import {IPermissionProvider} from "../../lib/cu-osc-common/src/interfaces/IPermissionProvider.sol";
import {LibEnvironment} from "../../lib/cu-osc-common/src/libraries/LibEnvironment.sol";
import {LibGasReturner} from "../../lib/cu-osc-common/src/libraries/LibGasReturner.sol";

contract AirlockFacet {
    //Airlock
    function lockLandIntoGame(uint256 tokenId) external {
        uint256 availableGas = gasleft();
        LibPermissions.enforceCallerOwnsNFTOrHasPermission(
            tokenId,
            IPermissionProvider.Permission.LAND_AIRLOCK_IN_ALLOWED
        );
        uint256 dna = LibLandDNA._getDNA(tokenId);
        require(dna > 0, "AirlockFacet: DNA not defined");
        LibLandDNA.enforceDNAVersionMatch(dna);
        require(
            LibLandDNA._getGameLocked(dna) == false,
            "AirlockFacet: Land must be unlocked to be locked."
        );
        LibLandDNA._enforceLandIsNotCoolingDown(tokenId);

        dna = LibLandDNA._setGameLocked(dna, true);
        LibLandDNA._setDNA(tokenId, dna);
        emit LibEvents.LandLockedIntoGame(tokenId, msg.sender);
        emit LibEvents.LandLockedIntoGameV2(
            tokenId,
            LibERC721.erc721Storage().owners[tokenId],
            msg.sender
        );
        LibGasReturner.returnGasToUser(
            "lockLandIntoGame",
            (availableGas - gasleft()),
            payable(msg.sender)
        );
    }

    function unlockLandOutOfGameGenerateMessageHash(
        uint256 tokenId,
        string memory tokenURI,
        uint256 _level,
        uint256 requestId,
        uint256 blockDeadline
    ) public view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(
                keccak256(
                    "UnlockLandOutOfGamePayload(uint256 tokenId, string memory tokenURI, uint256 _level, uint256 requestId, uint256 blockDeadline)"
                ),
                tokenId,
                tokenURI,
                _level,
                requestId,
                blockDeadline
            )
        );
        bytes32 digest = LibServerSideSigning._hashTypedDataV4(structHash);
        return digest;
    }

    function unlockLandOutOfGame(
        uint256 tokenId,
        string memory tokenURI,
        uint256 _level
    ) internal {
        LibPermissions.enforceCallerOwnsNFTOrHasPermission(
            tokenId,
            IPermissionProvider.Permission.LAND_AIRLOCK_OUT_ALLOWED
        );
        uint256 dna = LibLandDNA._getDNA(tokenId);
        LibLandDNA.enforceDNAVersionMatch(dna);
        require(
            LibLandDNA._getGameLocked(dna) == true,
            "AirlockFacet: unlockLandOutOfGameWithSignature -- Land must be locked to be unlocked."
        );
        LibLandDNA._enforceLandIsNotCoolingDown(tokenId);

        dna = LibLandDNA._setGameLocked(dna, false);
        dna = LibLandDNA._setLevel(dna, _level);
        LibLandDNA._setDNA(tokenId, dna);
        LibERC721.setTokenURI(tokenId, tokenURI);
        emit LibEvents.LandUnlockedOutOfGame(tokenId, msg.sender);
        emit LibEvents.LandUnlockedOutOfGameV2(
            tokenId,
            LibERC721.erc721Storage().owners[tokenId],
            msg.sender
        );
    }

    function unlockLandOutOfGameWithSignature(
        uint256 tokenId,
        string calldata tokenURI,
        uint256 _level,
        uint256 requestId,
        uint256 blockDeadline,
        bytes memory signature
    ) public {
        uint256 availableGas = gasleft();
        bytes32 hash = unlockLandOutOfGameGenerateMessageHash(
            tokenId,
            tokenURI,
            _level,
            requestId,
            blockDeadline
        );
        address gameServer = LibResourceLocator.gameServerSSS();
        require(
            SignatureChecker.isValidSignatureNow(gameServer, hash, signature),
            "AirlockFacet: unlockLandOutOfGameWithSignature -- Payload must be signed by game server"
        );
        require(
            !LibServerSideSigning._checkRequest(requestId),
            "AirlockFacet: unlockLandOutOfGameWithSignature -- Request has already been fulfilled"
        );
        require(
            LibEnvironment.getBlockNumber() <= blockDeadline,
            "AirlockFacet: unlockLandOutOfGameWithSignature -- Block deadline has expired"
        );
        LibServerSideSigning._completeRequest(requestId);
        unlockLandOutOfGame(tokenId, tokenURI, _level);
        LibGasReturner.returnGasToUser(
            "unlockLandOutOfGameWithSignature",
            (availableGas - gasleft()),
            payable(msg.sender)
        );
    }

    function landIsTransferrable(uint256 tokenId) public view returns (bool) {
        return LibLandDNA._landIsTransferrable(tokenId);
    }
}
