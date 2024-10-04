// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibBin} from "../../lib/cu-osc-common/src/libraries/LibBin.sol";
import {LibLand} from "./LibLand.sol";

library LibIdempotence {
    function _getIdempotenceState(
        uint256 _tokenId
    ) internal view returns (uint256) {
        LibLand.LandStorage storage ds = LibLand.landStorage();
        return ds.idempotence_state[_tokenId];
    }

    function _setIdempotenceState(
        uint256 _tokenId,
        uint256 _state
    ) internal returns (uint256) {
        LibLand.LandStorage storage ds = LibLand.landStorage();
        ds.idempotence_state[_tokenId] = _state;
        return _state;
    }

    function _clearState(uint256 _tokenId) internal {
        _setIdempotenceState(_tokenId, 0);
    }
}
