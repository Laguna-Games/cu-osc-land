// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibLandVendingEnvironmentConfig} from '../libraries/LibLandVendingEnvironmentConfig.sol';
import {LibPermissions} from '../libraries/LibPermissions.sol';

contract LandVendingConfigFacet {
    function loadLandVendingConfig() external {
        LibPermissions.enforceIsOwnerOrGameServer();
        LibLandVendingEnvironmentConfig.configureForMainnet();
    }
}
