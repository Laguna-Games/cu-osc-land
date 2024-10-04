// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LandImplementation} from './LandImplementation.sol';

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract LandImplementationTestnet is LandImplementation {
    function withdrawWeth(address _receiver, uint256 _amount) public {}

    function batchSetTokenURI(uint256[] calldata tokenIds, string[] calldata tokenURIs) external {}
}
