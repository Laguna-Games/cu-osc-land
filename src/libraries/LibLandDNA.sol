// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibBin} from '../../lib/@lagunagames/cu-common/src/libraries/LibBin.sol';
import {LibLand} from './LibLand.sol';
import {LibEvents} from './LibEvents.sol';

library LibLandDNA {
    uint256 internal constant DNA_VERSION = 1;

    uint256 public constant RARITY_MYTHIC = 1;
    uint256 public constant RARITY_RARE = 2;
    uint256 public constant RARITY_COMMON = 3;

    //  version is in bits 0-7 = 0b11111111
    uint256 internal constant DNA_VERSION_MASK = 0xFF;

    //  origin is in bits 8-9 = 0b1100000000
    uint256 internal constant DNA_ORIGIN_MASK = 0x300;

    //  locked is in bit 10 = 0b10000000000
    uint256 internal constant DNA_LOCKED_MASK = 0x400;

    //  limitedEdition is in bit 11 = 0b100000000000
    uint256 internal constant DNA_LIMITEDEDITION_MASK = 0x800;

    //  Futureproofing: Rarity derives from LandType but may be decoupled later
    //  rarity is in bits 12-13 = 0b11000000000000
    uint256 internal constant DNA_RARITY_MASK = 0x3000;

    //  landType is in bits 14-23 = 0b111111111100000000000000
    uint256 internal constant DNA_LANDTYPE_MASK = 0xFFC000;

    //  level is in bits 24-31 = 0b11111111000000000000000000000000
    uint256 internal constant DNA_LEVEL_MASK = 0xFF000000;

    //  firstName is in bits 32-41 = 0b111111111100000000000000000000000000000000
    uint256 internal constant DNA_FIRSTNAME_MASK = 0x3FF00000000;

    //  middleName is in bits 42-51 = 0b1111111111000000000000000000000000000000000000000000
    uint256 internal constant DNA_MIDDLENAME_MASK = 0xFFC0000000000;

    //  lastName is in bits 52-61 = 0b11111111110000000000000000000000000000000000000000000000000000
    uint256 internal constant DNA_LASTNAME_MASK = 0x3FF0000000000000;

    function _getDNA(uint256 _tokenId) internal view returns (uint256) {
        return LibLand.landStorage().land_dna[_tokenId];
    }

    function _setDNA(uint256 _tokenId, uint256 _dna) internal returns (uint256) {
        require(_dna > 0, 'LibLandDNA: cannot set 0 DNA');
        LibLand.LandStorage storage ds = LibLand.landStorage();
        ds.land_dna[_tokenId] = _dna;
        emit LibEvents.DNAUpdated(_tokenId, ds.land_dna[_tokenId]);
        return ds.land_dna[_tokenId];
    }

    function _getVersion(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_VERSION_MASK);
    }

    function _setVersion(uint256 _dna, uint256 _version) internal pure returns (uint256) {
        return LibBin.splice(_dna, _version, DNA_VERSION_MASK);
    }

    function _getOrigin(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_ORIGIN_MASK);
    }

    function _setOrigin(uint256 _dna, uint256 _origin) internal pure returns (uint256) {
        return LibBin.splice(_dna, _origin, DNA_ORIGIN_MASK);
    }

    function _getGameLocked(uint256 _dna) internal pure returns (bool) {
        return LibBin.extractBool(_dna, DNA_LOCKED_MASK);
    }

    function _setGameLocked(uint256 _dna, bool _val) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_LOCKED_MASK);
    }

    function _getLimitedEdition(uint256 _dna) internal pure returns (bool) {
        return LibBin.extractBool(_dna, DNA_LIMITEDEDITION_MASK);
    }

    function _setLimitedEdition(uint256 _dna, bool _val) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_LIMITEDEDITION_MASK);
    }

    function _getClass(uint256 _dna) internal view returns (uint256) {
        return LibLand.landStorage().classByLandType[_getLandType(_dna)];
    }

    function _getClassGroup(uint256 _dna) internal view returns (uint256) {
        return LibLand.landStorage().classGroupByLandType[_getLandType(_dna)];
    }

    function _getMythic(uint256 _dna) internal view returns (bool) {
        return LibLand.landStorage().rarityByLandType[_getLandType(_dna)] == RARITY_MYTHIC;
    }

    function _getRarity(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_RARITY_MASK);
    }

    function _setRarity(uint256 _dna, uint256 _rarity) internal pure returns (uint256) {
        return LibBin.splice(_dna, _rarity, DNA_RARITY_MASK);
    }

    function _getLandType(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_LANDTYPE_MASK);
    }

    function _setLandType(uint256 _dna, uint256 _landType) internal pure returns (uint256) {
        return LibBin.splice(_dna, _landType, DNA_LANDTYPE_MASK);
    }

    function _getLevel(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_LEVEL_MASK);
    }

    function _setLevel(uint256 _dna, uint256 _level) internal pure returns (uint256) {
        return LibBin.splice(_dna, _level, DNA_LEVEL_MASK);
    }

    function _getFirstNameIndex(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_FIRSTNAME_MASK);
    }

    function _setFirstNameIndex(uint256 _dna, uint256 _index) internal pure returns (uint256) {
        return LibBin.splice(_dna, _index, DNA_FIRSTNAME_MASK);
    }

    function _getMiddleNameIndex(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_MIDDLENAME_MASK);
    }

    function _setMiddleNameIndex(uint256 _dna, uint256 _index) internal pure returns (uint256) {
        return LibBin.splice(_dna, _index, DNA_MIDDLENAME_MASK);
    }

    function _getLastNameIndex(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_LASTNAME_MASK);
    }

    function _setLastNameIndex(uint256 _dna, uint256 _index) internal pure returns (uint256) {
        return LibBin.splice(_dna, _index, DNA_LASTNAME_MASK);
    }

    function enforceDNAVersionMatch(uint256 _dna) internal pure {
        require(_getVersion(_dna) == DNA_VERSION, 'LibLandDNA: Invalid DNA version');
    }

    function _landIsTransferrable(uint256 tokenId) internal view returns (bool) {
        if (_getGameLocked(_getDNA(tokenId))) {
            return false;
        }
        LibLand.LandStorage storage ds = LibLand.landStorage();
        bool coolingDownFromForceUnlock = (ds.landLastForceUnlock[tokenId] + ds.forceUnlockLandCooldown) >=
            block.timestamp;

        return !coolingDownFromForceUnlock;
    }

    function _enforceLandIsNotCoolingDown(uint256 tokenId) internal view {
        LibLand.LandStorage storage ds = LibLand.landStorage();
        bool coolingDownFromForceUnlock = (ds.landLastForceUnlock[tokenId] + ds.forceUnlockLandCooldown) >=
            block.timestamp;
        require(!coolingDownFromForceUnlock, 'LibLandDNA: Land cooling down from force unlock');
    }
}
