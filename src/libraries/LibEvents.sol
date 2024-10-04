// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

library LibEvents {
    event DNAUpdated(uint256 tokenId, uint256 dna);

    //Airlock
    event LandLockedIntoGame(uint256 tokenId, address locker);
    event LandLockedIntoGameV2(uint256 indexed tokenId, address indexed owner, address locker);
    event LandUnlockedOutOfGame(uint256 tokenId, address locker);
    event LandUnlockedOutOfGameV2(uint256 indexed tokenId, address indexed owner, address locker);
    event LandUnlockedOutOfGameForcefully(uint256 tokenId, address locker);

    //Land
    event LandMinted(uint8 indexed landType, uint256 tokenId, address owner);

    //Land vending
    event BeginLVMMinting(uint256 indexed tokenId, string indexed fullName, uint256 indexed landType);
}
