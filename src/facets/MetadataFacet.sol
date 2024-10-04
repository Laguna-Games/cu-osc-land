// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibLandDNA} from "../libraries/LibLandDNA.sol";
import {LibLandNames} from "../libraries/LibLandNames.sol";
import {LibLand} from "../libraries/LibLand.sol";

contract MetadataFacet {
    function getLandMetaData(
        uint256 _tokenId
    )
        external
        view
        returns (
            string memory tokenURI,
            uint8 origin,
            bool gameLocked,
            bool limitedEdition,
            uint8 rarity,
            uint16 landType,
            uint8 class,
            uint8 classGroup,
            uint8 level,
            string memory fullName,
            bool mythic
        )
    {
        LibERC721.ERC721Storage storage es = LibERC721.erc721Storage();
        LibLand.LandStorage storage ls = LibLand.landStorage();

        tokenURI = es.tokenURIs[_tokenId];
        uint256 dna = ls.land_dna[_tokenId];
        LibLandDNA.enforceDNAVersionMatch(dna);
        origin = uint8(LibLandDNA._getOrigin(dna));
        gameLocked = LibLandDNA._getGameLocked(dna);
        limitedEdition = LibLandDNA._getLimitedEdition(dna);
        rarity = uint8(LibLandDNA._getRarity(dna));
        landType = uint16(LibLandDNA._getLandType(dna));
        class = uint8(LibLandDNA._getClass(dna));
        classGroup = uint8(LibLandDNA._getClassGroup(dna));
        level = uint8(LibLandDNA._getLevel(dna));
        fullName = LibLandNames._getFullNameFromDNA(dna);
        mythic = LibLandDNA._getMythic(dna);
    }

    function getAllLandIdsForOwner(
        address _owner
    ) external view returns (uint256[] memory) {
        LibERC721.ERC721Storage storage es = LibERC721.erc721Storage();
        uint256 balance = es.balances[_owner];
        uint256[] memory ids = new uint256[](balance);
        for (uint256 i = 0; i < balance; ++i) {
            ids[i] = es.ownedTokens[_owner][i];
        }
        return ids;
    }

    //  Returns paginated metadata of a player's tokens. Max page size is 12,
    //  smaller arrays are returned on the final page to fit the player's
    //  inventory. The `moreEntriesExist` flag is TRUE when additional pages
    //  are available past the current call.
    function getLandsByOwner(
        address _owner,
        uint32 _pageNumber
    )
        external
        view
        returns (
            uint256[] memory tokenIds,
            uint16[] memory landTypes,
            string[] memory names,
            bool[] memory gameLocked,
            bool moreEntriesExist
        )
    {
        LibERC721.ERC721Storage storage es = LibERC721.erc721Storage();
        LibLand.LandStorage storage ls = LibLand.landStorage();

        uint256 balance = es.balances[_owner];
        uint256 start = _pageNumber * 12;
        uint256 count = balance - start;
        if (count > 12) {
            count = 12;
            moreEntriesExist = true;
        }

        tokenIds = new uint256[](count);
        landTypes = new uint16[](count);
        names = new string[](count);
        gameLocked = new bool[](count);

        for (uint256 i = 0; i < count; ++i) {
            uint256 indx = start + i;
            uint256 tokenId = es.ownedTokens[_owner][indx];
            tokenIds[i] = tokenId;
            landTypes[i] = uint8(LibLandDNA._getLandType(ls.land_dna[tokenId]));
            names[i] = LibLandNames._getFullName(tokenId);
            gameLocked[i] = LibLandDNA._getGameLocked(ls.land_dna[tokenId]);
        }
    }
}
