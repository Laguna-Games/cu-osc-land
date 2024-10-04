// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import {LibRNG} from "../../lib/cu-osc-common/src/libraries/LibRNG.sol";
import {LibLandDNA} from "./LibLandDNA.sol";
import {LibLand} from "./LibLand.sol";

/// @custom:storage-location erc7201:games.laguna.LibLandNames
library LibLandNames {
    bytes32 public constant LAND_NAMES_STORAGE_POSITION =
        keccak256(
            abi.encode(uint256(keccak256("games.laguna.LibLandNames")) - 1)
        ) & ~bytes32(uint256(0xff));

    struct LandNameStorage {
        // nameIndex -> name string
        mapping(uint256 => string) firstNamesList;
        mapping(uint256 => string) middleNamesList;
        mapping(uint256 => string) lastNamesList;
        // Names which can be chosen by RNG for new lands (unordered)
        uint256[] validFirstNames;
        uint256[] validMiddleNames;
        uint256[] validLastNames;
    }

    function landNameStorage()
        internal
        pure
        returns (LandNameStorage storage lns)
    {
        bytes32 position = LAND_NAMES_STORAGE_POSITION;
        assembly {
            lns.slot := position
        }
    }

    function _lookupFirstName(
        uint256 _nameId
    ) internal view returns (string memory) {
        return landNameStorage().firstNamesList[_nameId];
    }

    function _lookupMiddleName(
        uint256 _nameId
    ) internal view returns (string memory) {
        return landNameStorage().middleNamesList[_nameId];
    }

    function _lookupLastName(
        uint256 _nameId
    ) internal view returns (string memory) {
        return landNameStorage().lastNamesList[_nameId];
    }

    function _getFullName(
        uint256 _tokenId
    ) internal view returns (string memory) {
        return _getFullNameFromDNA(LibLand.landStorage().land_dna[_tokenId]);
    }

    function _getFullNameString(
        uint256 _tokenId
    ) internal view returns (string memory) {
        uint256 _dna = LibLand.landStorage().land_dna[_tokenId];
        LibLandDNA.enforceDNAVersionMatch(_dna);
        LandNameStorage storage ds = landNameStorage();
        return
            string.concat(
                ds.firstNamesList[LibLandDNA._getFirstNameIndex(_dna)],
                " ",
                ds.middleNamesList[LibLandDNA._getMiddleNameIndex(_dna)],
                " ",
                ds.lastNamesList[LibLandDNA._getLastNameIndex(_dna)]
            );
    }

    function _getFullNameFromDNA(
        uint256 _dna
    ) internal view returns (string memory) {
        LibLandDNA.enforceDNAVersionMatch(_dna);
        LandNameStorage storage ds = landNameStorage();
        return
            string(
                abi.encodePacked(
                    ds.firstNamesList[LibLandDNA._getFirstNameIndex(_dna)],
                    " ",
                    ds.middleNamesList[LibLandDNA._getMiddleNameIndex(_dna)],
                    " ",
                    ds.lastNamesList[LibLandDNA._getLastNameIndex(_dna)]
                )
            );
    }

    function _getRandomName() internal returns (uint256[3] memory) {
        LandNameStorage storage ds = landNameStorage();
        require(
            ds.validFirstNames.length > 0,
            "NamesFacet: First-name list is empty"
        );
        require(
            ds.validMiddleNames.length > 0,
            "NamesFacet: Middle-name list is empty"
        );
        require(
            ds.validLastNames.length > 0,
            "NamesFacet: Last-name list is empty"
        );
        return [
            ds.validFirstNames[LibRNG.getRuntimeRNG(ds.validFirstNames.length)],
            ds.validMiddleNames[
                LibRNG.getRuntimeRNG(ds.validMiddleNames.length)
            ],
            ds.validLastNames[LibRNG.getRuntimeRNG(ds.validLastNames.length)]
        ];
    }
}
