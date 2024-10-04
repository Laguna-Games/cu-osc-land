// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from '../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import {LibResourceLocator} from '../../lib/@lagunagames/cu-common/src/libraries/LibResourceLocator.sol';
import {LibContractOwner} from '../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol';
import {LibERC721} from '../../lib/@lagunagames/cu-tokens/src/libraries/LibERC721.sol';
import {LibLand} from '../libraries/LibLand.sol';
import {LibPermissions} from '../libraries/LibPermissions.sol';
import {LibLandDNA} from '../libraries/LibLandDNA.sol';
import {LibValidate} from '../../lib/@lagunagames/cu-common/src/libraries/LibValidate.sol';
import {LibAccessBadge} from '../../lib/@lagunagames/cu-common/src/libraries/LibAccessBadge.sol';

contract LandsFacet {
    function paymentToken() external view returns (address) {
        return LibResourceLocator.wethToken();
    }

    function getLandTypeByTokenId(uint256 tokenId) external view returns (uint8) {
        return uint8(LibLandDNA._getLandType(LibLandDNA._getDNA(tokenId)));
    }

    function getPaymentToken() internal view returns (IERC20) {
        return IERC20(LibResourceLocator.wethToken());
    }

    function withdrawWeth(address _receiver, uint256 _amount) public {
        LibContractOwner.enforceIsContractOwner();
        require(
            msg.sender == _receiver,
            'ERC721Facet: This contract currently only supports its owner withdrawing to self'
        );
        getPaymentToken().transfer(_receiver, _amount);
    }

    function changeContractURI(string memory _contractURI) public {
        LibContractOwner.enforceIsContractOwner();
        LibERC721.erc721Storage().contractURI = _contractURI;
    }

    function changeLicenseURI(string memory _licenseURI) public {
        LibContractOwner.enforceIsContractOwner();
        LibERC721.erc721Storage().licenseURI = _licenseURI;
    }

    function batchSetTokenURI(uint256[] calldata tokenIds, string[] calldata tokenURIs) external {
        LibPermissions.enforceIsOwnerOrGameServer();
        for (uint256 i = 0; i < tokenIds.length; i++) {
            LibERC721.setTokenURI(tokenIds[i], tokenURIs[i]);
        }
    }

    function batchSetTokenURIAndLevel(
        uint256[] calldata tokenIds,
        string[] calldata tokenURIs,
        uint256[] calldata levels
    ) external {
        LibAccessBadge.requireBadge('migrator');
        LibValidate.enforceNonEmptyUintArray(tokenIds);
        require(tokenIds.length == tokenURIs.length && tokenIds.length == levels.length, 'Length mismatch');
        for (uint256 i = 0; i < tokenIds.length; i++) {
            LibERC721.setTokenURI(tokenIds[i], tokenURIs[i]);
            uint256 dna = LibLandDNA._setLevel(LibLandDNA._getDNA(tokenIds[i]), levels[i]);
            LibLandDNA._setDNA(tokenIds[i], dna);
        }
    }

    function getNumMintedTokensByLandType()
        external
        view
        returns (
            uint256 mythic,
            uint256 rareLight,
            uint256 rareWonder,
            uint256 rareMystery,
            uint256 commonHeart,
            uint256 commonCloud,
            uint256 commonFlower,
            uint256 commonCandy,
            uint256 commonCrystal,
            uint256 commonMoon
        )
    {
        LibLand.LandStorage storage ls = LibLand.landStorage();
        mythic = ls.numMintedTokensByLandType[1];
        rareLight = ls.numMintedTokensByLandType[2];
        rareWonder = ls.numMintedTokensByLandType[3];
        rareMystery = ls.numMintedTokensByLandType[4];
        commonHeart = ls.numMintedTokensByLandType[5];
        commonCloud = ls.numMintedTokensByLandType[6];
        commonFlower = ls.numMintedTokensByLandType[7];
        commonCandy = ls.numMintedTokensByLandType[8];
        commonCrystal = ls.numMintedTokensByLandType[9];
        commonMoon = ls.numMintedTokensByLandType[10];
    }
}
