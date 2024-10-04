// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibLandNames} from "../libraries/LibLandNames.sol";

contract NamesFacet {
    function lookupFirstName(uint256 _nameId) external view returns (string memory) {
        return LibLandNames._lookupFirstName(_nameId);
    }

    function lookupMiddleName(uint256 _nameId) external view returns (string memory) {
        return LibLandNames._lookupMiddleName(_nameId);
    }

    function lookupLastName(uint256 _nameId) external view returns (string memory) {
        return LibLandNames._lookupLastName(_nameId);
    }

    function getFullName(uint256 _tokenId) external view returns (string memory) {
        return LibLandNames._getFullName(_tokenId);
    }

    function getFullNameFromDNA(uint256 _dna) public view returns (string memory) {
        return LibLandNames._getFullNameFromDNA(_dna);
    }
}
