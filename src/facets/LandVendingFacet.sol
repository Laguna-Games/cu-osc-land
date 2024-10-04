// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibLandVending} from '../libraries/LibLandVending.sol';
// import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibContractOwner} from '../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol';
import {LibPermissions} from '../libraries/LibPermissions.sol';

contract LandVendingFacet {
    function getLandInventory() external view returns (uint256[2][13] memory) {
        return LibLandVending.getLandInventory();
    }

    //Begin mint function for the land vending machine website only
    function beginKeystoneToLand(
        uint256 price,
        uint8 landType,
        uint256 slippage
    ) external returns (uint256, string memory) {
        return LibLandVending.beginKeystoneToLand(price, landType, slippage);
    }

    function batchFinishMinting(uint256[] calldata tokenIds, string[] calldata tokenURIs) external {
        LibPermissions.enforceIsOwnerOrGameServer();
        LibLandVending.batchFinishMinting(tokenIds, tokenURIs);
    }

    function setMaxLandsByLandType(uint8 landType, uint256 max) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setMaxLandsByLandType(landType, max);
    }

    function setFirstPhaseQuantityByLandType(uint8 landType, uint256 quantity) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setFirstPhaseQuantityByLandType(landType, quantity);
    }

    function setSecondPhaseQuantityByLandType(uint8 landType, uint256 quantity) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setSecondPhaseQuantityByLandType(landType, quantity);
    }

    function setBeginningByLandTypeAndPhase(uint8 landType, uint256 phase, uint256 beginning) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setBeginningByLandTypeAndPhase(landType, phase, beginning);
    }

    function setEndByLandTypeAndPhase(uint8 landType, uint256 phase, uint256 end) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setEndByLandTypeAndPhase(landType, phase, end);
    }

    function setKeystonePoolIdByLandType(uint8 landType, uint256 keystonePoolId) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setKeystonePoolIdByLandType(landType, keystonePoolId);
    }

    function setLandVendingStartingIndexByLandType(uint8 landType, uint256 startIndex) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setLandVendingStartingIndexByLandType(landType, startIndex);
    }

    function setCommonOwedRBW(uint256 amount) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setCommonOwedRBW(amount);
    }

    function setRareOwedRBW(uint256 amount) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setRareOwedRBW(amount);
    }

    function setMythicOwedRBW(uint256 amount) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setMythicOwedRBW(amount);
    }

    function setOwedUNIM(uint256 amount) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setOwedUNIM(amount);
    }

    function setDefaultTokenURIByLandType(uint8 landType, string memory tokenURI) external {
        LibContractOwner.enforceIsContractOwner();
        LibLandVending.setDefaultTokenURIByLandType(landType, tokenURI);
    }

    function getMaxLandByLandType(uint8 landType) external view returns (uint256) {
        return LibLandVending.getMaxLandByLandType(landType);
    }

    function getCommonOwedRBW() external view returns (uint256) {
        return LibLandVending.getCommonOwedRBW();
    }

    function getRareOwedRBW() external view returns (uint256) {
        return LibLandVending.getRareOwedRBW();
    }

    function getMythicOwedRBW() external view returns (uint256) {
        return LibLandVending.getMythicOwedRBW();
    }

    function getOwedUNIM() external view returns (uint256) {
        return LibLandVending.getOwedUNIM();
    }

    function getLandVendingStartingIndexByLandType(uint8 landType) external view returns (uint256) {
        return LibLandVending.getLandVendingStartingIndexByLandType(landType);
    }

    function getKeystonePoolIdByLandType(uint8 landType) external view returns (uint256) {
        return LibLandVending.getKeystonePoolIdByLandType(landType);
    }

    function getFirstPhaseQuantityByLandType(uint8 landType) external view returns (uint256) {
        return LibLandVending.getFirstPhaseQuantityByLandType(landType);
    }

    function getSecondPhaseQuantityByLandType(uint8 landType) external view returns (uint256) {
        return LibLandVending.getSecondPhaseQuantityByLandType(landType);
    }

    function getBeginningByLandTypeAndPhase(uint8 landType, uint256 phase) external view returns (uint256) {
        return LibLandVending.getBeginningByLandTypeAndPhase(landType, phase);
    }

    function getEndByLandTypeAndPhase(uint8 landType, uint256 phase) external view returns (uint256) {
        return LibLandVending.getEndByLandTypeAndPhase(landType, phase);
    }

    function getCurrentLandByLandType(uint8 landType) external view returns (uint256) {
        return LibLandVending.getCurrentLandByLandType(landType);
    }

    function getDefaultTokenURIByLandType(uint8 landType) external view returns (string memory) {
        return LibLandVending.getDefaultTokenURIByLandType(landType);
    }
}
