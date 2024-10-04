// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {LibEnvironment} from "../../lib/cu-osc-common/src/libraries/LibEnvironment.sol";

/// @custom:storage-location erc7201:games.laguna.LibLand
library LibLand {
    bytes32 public constant LAND_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256("games.laguna.LibLand")) - 1)) &
            ~bytes32(uint256(0xff));

    struct LandStorage {
        // Land types
        // 1 = mythic
        // 2 = rare (light)
        // 3 = rare (wonder)
        // 4 = rare (mystery)
        // 5 = common (heart)
        // 6 = common (cloud)
        // 7 = common (flower)
        // 8 = common (candy)
        // 9 = common (crystal)
        // 10 = common (moon)
        // 11 = Rainbow + the suffix (hidden)
        // 12 = Omnom + the suffix (hidden)
        // 13 = Star + the suffix (hidden)

        // (1-13) land type -> number of tokens minted with that land type
        mapping(uint8 => uint256) numMintedTokensByLandType;
        // Land token -> DNA mapping. DNA is represented by a uint256.
        mapping(uint256 => uint256) land_dna;
        // The state of the NFT when it is round-tripping with the server
        mapping(uint256 => uint256) idempotence_state;
        // LandType -> ClassId
        mapping(uint256 => uint256) classByLandType;
        // LandType -> ClassGroupId
        mapping(uint256 => uint256) classGroupByLandType;
        // LandType -> rarityId
        mapping(uint256 => uint256) rarityByLandType;
        // // Land token -> Last timestamp when it was unlocked forcefully
        mapping(uint256 => uint256) landLastForceUnlock;
        // // When a land is unlocked forcefully, user has to wait forceUnlockLandCooldown seconds to be able to transfer
        uint256 forceUnlockLandCooldown;
    }

    function landStorage() internal pure returns (LandStorage storage lns) {
        bytes32 position = LAND_STORAGE_POSITION;
        assembly {
            lns.slot := position
        }
    }

    function enforceBlockDeadlineIsValid(uint256 blockDeadline) internal view {
        require(
            LibEnvironment.getBlockNumber() < blockDeadline,
            "blockDeadline is overdue"
        );
    }
}
