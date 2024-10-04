// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// LibLandFaucet implements the Diamond storage pattern for the Crypto Unicorns Gems contract.
// It also contains several internal methods which make it convenient to interact with Gems storage.
library LibLandFaucet {
    struct LandsFaucetStorage {
        uint256 mintedLands;
    }

    bytes32 private constant LANDS_FAUCET_STORAGE_POSITION = keccak256('CryptoUnicorns.GemsFaucet.storage');

    function landsFaucetStorage() internal pure returns (LandsFaucetStorage storage lfs) {
        bytes32 position = LANDS_FAUCET_STORAGE_POSITION;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            lfs.slot := position
        }
    }

    function getNextTokenId() internal returns (uint256) {
        landsFaucetStorage().mintedLands++;
        return 1000000 + landsFaucetStorage().mintedLands;
    }
}
