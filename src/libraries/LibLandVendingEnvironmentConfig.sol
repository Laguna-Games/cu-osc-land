// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibLandVending} from "./LibLandVending.sol";
import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibLand} from "./LibLand.sol";
import {LibRNG} from "../../lib/cu-osc-common/src/libraries/LibRNG.sol";

library LibLandVendingEnvironmentConfig {
    function configureForMainnet() internal {
        LibERC721.erc721Storage().name = "Unicorn Farm";
        LibERC721.erc721Storage().symbol = "UNIF";
        //TODO: This contractURI is outdated, it's supposed to be in Polygon not XAI. Update it.
        LibERC721
            .erc721Storage()
            .contractURI = "https://arweave.net/HNvtS6fber4NC80_sEd0MAiUr7UyA3R4GpEFFqyRZAk";
        LibERC721
            .erc721Storage()
            .licenseURI = "https://arweave.net/520gStGJ4Fla9GeG0U9UIm1vYnei8dOnDfznCaJy0IY";
        LibLand.landStorage().forceUnlockLandCooldown = 86400;
        LibRNG.rngStorage().rngNonce = 10000000;
        initialLandVendingLoad();
        initInfoByLandType();
    }

    function initialLandVendingLoad() private {
        //firstPhaseQuantityByLandType
        LibLandVending.setFirstPhaseQuantityByLandType(1, 2400);
        LibLandVending.setFirstPhaseQuantityByLandType(2, 9000);
        LibLandVending.setFirstPhaseQuantityByLandType(3, 9000);
        LibLandVending.setFirstPhaseQuantityByLandType(4, 9000);
        LibLandVending.setFirstPhaseQuantityByLandType(5, 32100);
        LibLandVending.setFirstPhaseQuantityByLandType(6, 32100);
        LibLandVending.setFirstPhaseQuantityByLandType(7, 32100);
        LibLandVending.setFirstPhaseQuantityByLandType(8, 32100);
        LibLandVending.setFirstPhaseQuantityByLandType(9, 32100);
        LibLandVending.setFirstPhaseQuantityByLandType(10, 32100);
        LibLandVending.setFirstPhaseQuantityByLandType(11, 33100);
        LibLandVending.setFirstPhaseQuantityByLandType(12, 33100);
        LibLandVending.setFirstPhaseQuantityByLandType(13, 33100);

        //secondPhaseQuantityByLandType
        LibLandVending.setSecondPhaseQuantityByLandType(1, 2300);
        LibLandVending.setSecondPhaseQuantityByLandType(2, 8900);
        LibLandVending.setSecondPhaseQuantityByLandType(3, 8900);
        LibLandVending.setSecondPhaseQuantityByLandType(4, 8900);
        LibLandVending.setSecondPhaseQuantityByLandType(5, 32000);
        LibLandVending.setSecondPhaseQuantityByLandType(6, 32000);
        LibLandVending.setSecondPhaseQuantityByLandType(7, 32000);
        LibLandVending.setSecondPhaseQuantityByLandType(8, 32000);
        LibLandVending.setSecondPhaseQuantityByLandType(9, 32000);
        LibLandVending.setSecondPhaseQuantityByLandType(10, 32000);
        LibLandVending.setSecondPhaseQuantityByLandType(11, 33000);
        LibLandVending.setSecondPhaseQuantityByLandType(12, 33000);
        LibLandVending.setSecondPhaseQuantityByLandType(13, 33000);

        //maxLandsByLandType
        LibLandVending.setMaxLandsByLandType(1, 7000);
        LibLandVending.setMaxLandsByLandType(2, 27000);
        LibLandVending.setMaxLandsByLandType(3, 27000);
        LibLandVending.setMaxLandsByLandType(4, 27000);
        LibLandVending.setMaxLandsByLandType(5, 97000);
        LibLandVending.setMaxLandsByLandType(6, 97000);
        LibLandVending.setMaxLandsByLandType(7, 97000);
        LibLandVending.setMaxLandsByLandType(8, 97000);
        LibLandVending.setMaxLandsByLandType(9, 97000);
        LibLandVending.setMaxLandsByLandType(10, 97000);
        LibLandVending.setMaxLandsByLandType(11, 100000);
        LibLandVending.setMaxLandsByLandType(12, 100000);
        LibLandVending.setMaxLandsByLandType(13, 100000);

        //owedRBW - This is already in CU tokens pricing (polygonOwedRBW/10)
        LibLandVending.setCommonOwedRBW(20000000000000000000);
        LibLandVending.setRareOwedRBW(40000000000000000000);
        LibLandVending.setMythicOwedRBW(60000000000000000000);

        //owedUNIM
        LibLandVending.setOwedUNIM(1000000000000000000000);

        //beginningByLandTypeAndPhase;
        LibLandVending.setBeginningByLandTypeAndPhase(1, 1, 100000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(1, 2, 500000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(1, 3, 700000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(2, 1, 50000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(2, 2, 200000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(2, 3, 300000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(3, 1, 50000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(3, 2, 200000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(3, 3, 300000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(4, 1, 50000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(4, 2, 200000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(4, 3, 300000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(5, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(5, 2, 100000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(5, 3, 150000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(6, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(6, 2, 100000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(6, 3, 150000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(7, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(7, 2, 100000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(7, 3, 150000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(8, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(8, 2, 100000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(8, 3, 150000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(9, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(9, 2, 100000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(9, 3, 150000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(10, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(
            10,
            2,
            100000000000000000
        );
        LibLandVending.setBeginningByLandTypeAndPhase(
            10,
            3,
            150000000000000000
        );
        LibLandVending.setBeginningByLandTypeAndPhase(11, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(
            11,
            2,
            100000000000000000
        );
        LibLandVending.setBeginningByLandTypeAndPhase(
            11,
            3,
            150000000000000000
        );
        LibLandVending.setBeginningByLandTypeAndPhase(12, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(
            12,
            2,
            100000000000000000
        );
        LibLandVending.setBeginningByLandTypeAndPhase(
            12,
            3,
            150000000000000000
        );
        LibLandVending.setBeginningByLandTypeAndPhase(13, 1, 25000000000000000);
        LibLandVending.setBeginningByLandTypeAndPhase(
            13,
            2,
            100000000000000000
        );
        LibLandVending.setBeginningByLandTypeAndPhase(
            13,
            3,
            150000000000000000
        );

        //endByLandTypeAndPhase;
        LibLandVending.setEndByLandTypeAndPhase(1, 1, 500000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(1, 2, 700000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(1, 3, 800000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(2, 1, 200000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(2, 2, 300000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(2, 3, 350000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(3, 1, 200000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(3, 2, 300000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(3, 3, 350000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(4, 1, 200000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(4, 2, 300000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(4, 3, 350000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(5, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(5, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(5, 3, 175000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(6, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(6, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(6, 3, 175000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(7, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(7, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(7, 3, 175000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(8, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(8, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(8, 3, 175000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(9, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(9, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(9, 3, 175000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(10, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(10, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(10, 3, 175000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(11, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(11, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(11, 3, 175000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(12, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(12, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(12, 3, 175000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(13, 1, 100000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(13, 2, 150000000000000000);
        LibLandVending.setEndByLandTypeAndPhase(13, 3, 175000000000000000);

        //defaultTokenURIByLandType;
        LibLandVending.setDefaultTokenURIByLandType(
            1,
            "http://arweave.net/EQiRNC3DUfVd3ClYWwfshrEdGCyGWcj-qPo-zvfvyl0"
        ); //  mythic
        LibLandVending.setDefaultTokenURIByLandType(
            2,
            "http://arweave.net/iatq03tP1SUabHFk-GLHueqc3mifSlKiX1bpNnJG3kM"
        ); //  light
        LibLandVending.setDefaultTokenURIByLandType(
            3,
            "http://arweave.net/52NBI6ei0XSed2Gp4ozR2mznjKsiIKmHwrREpSqSRoQ"
        ); //  wonder
        LibLandVending.setDefaultTokenURIByLandType(
            4,
            "http://arweave.net/HNhW77ri-4I-UXvcbGJim-t9dVAWYnRHcB_9LCXvbto"
        ); //  mystery
        LibLandVending.setDefaultTokenURIByLandType(
            5,
            "http://arweave.net/7kHhp35gKyjLi-GXK4jlWG-kFADEZ0rQWyviqh0bbSo"
        ); //  heart
        LibLandVending.setDefaultTokenURIByLandType(
            6,
            "http://arweave.net/OPWJpYRixaNbUXI19XtSeauX9ea9fN3q8IManW8RbB0"
        ); //  cloud
        LibLandVending.setDefaultTokenURIByLandType(
            7,
            "http://arweave.net/_eZq8XhlUcs5cvJ9ISO1aGzpt9b5KC3hy9yn0hPsx8k"
        ); //  flower
        LibLandVending.setDefaultTokenURIByLandType(
            8,
            "http://arweave.net/HiHRkizwT71OzBOE09nzbb7uHtIXSBltRPrtLXo8n_I"
        ); //  candy
        LibLandVending.setDefaultTokenURIByLandType(
            9,
            "http://arweave.net/G7qTN8klYJvY-UKZQSeReE6ZAhMag3QigOuSeoqYNuU"
        ); //  crystal
        LibLandVending.setDefaultTokenURIByLandType(
            10,
            "http://arweave.net/owcjPqoPSqVELn7iXKjm24SdQY_dqo53tTPrDddTNuk"
        ); //  moon
        LibLandVending.setDefaultTokenURIByLandType(
            11,
            "http://arweave.net/1S7zlsAkyQ16yJPNqnwnCDEmR39rDhE_bhgDagyuxNQ"
        ); //  rainbow
        LibLandVending.setDefaultTokenURIByLandType(
            12,
            "http://arweave.net/Mhok59jWqz6LfUnjZ8ACwgD0UFJfFkSfUSTzx9XNKvM"
        ); //  omnom
        LibLandVending.setDefaultTokenURIByLandType(
            13,
            "http://arweave.net/o1CaszjL8WIxpbZsPMEbP9gOCP4lji_Ouv9v77lMJ6w"
        ); //  star

        //keystonePoolIdByLandType
        LibLandVending.setKeystonePoolIdByLandType(1, 19); // mythic
        LibLandVending.setKeystonePoolIdByLandType(2, 16); // light
        LibLandVending.setKeystonePoolIdByLandType(3, 23); // wonder
        LibLandVending.setKeystonePoolIdByLandType(4, 18); // mystery
        LibLandVending.setKeystonePoolIdByLandType(5, 15); // heart
        LibLandVending.setKeystonePoolIdByLandType(6, 12); // cloud
        LibLandVending.setKeystonePoolIdByLandType(7, 14); // flower
        LibLandVending.setKeystonePoolIdByLandType(8, 11); // candy
        LibLandVending.setKeystonePoolIdByLandType(9, 13); // crystal
        LibLandVending.setKeystonePoolIdByLandType(10, 17); // moon
        LibLandVending.setKeystonePoolIdByLandType(11, 21); // rainbow
        LibLandVending.setKeystonePoolIdByLandType(12, 20); // omnom
        LibLandVending.setKeystonePoolIdByLandType(13, 22); // star

        //landVendingStartingIndexesByLandType
        LibLandVending.setLandVendingStartingIndexByLandType(1, 30001); // mythic
        LibLandVending.setLandVendingStartingIndexByLandType(2, 37001); // light
        LibLandVending.setLandVendingStartingIndexByLandType(3, 64001); // wonder
        LibLandVending.setLandVendingStartingIndexByLandType(4, 91001); // mystery
        LibLandVending.setLandVendingStartingIndexByLandType(5, 118001); // heart
        LibLandVending.setLandVendingStartingIndexByLandType(6, 215001); // cloud
        LibLandVending.setLandVendingStartingIndexByLandType(7, 312001); // flower
        LibLandVending.setLandVendingStartingIndexByLandType(8, 409001); // candy
        LibLandVending.setLandVendingStartingIndexByLandType(9, 506001); // crystal
        LibLandVending.setLandVendingStartingIndexByLandType(10, 603000); // moon
        LibLandVending.setLandVendingStartingIndexByLandType(11, 700001); // rainbow
        LibLandVending.setLandVendingStartingIndexByLandType(12, 800001); // omnom
        LibLandVending.setLandVendingStartingIndexByLandType(13, 900001); // star
    }

    function initInfoByLandType() internal {
        LibLand.LandStorage storage ls = LibLand.landStorage();

        // landType 1 = mythic
        ls.rarityByLandType[1] = 1;
        ls.classGroupByLandType[1] = 0;
        ls.classByLandType[1] = 0;

        // landType 2 = rare (light)
        ls.rarityByLandType[2] = 2;
        ls.classGroupByLandType[2] = 0;
        ls.classByLandType[2] = 0;

        // landType 3 = rare (wonder)
        ls.rarityByLandType[3] = 2;
        ls.classGroupByLandType[3] = 1;
        ls.classByLandType[3] = 0;

        // landType 4 = rare (mystery)
        ls.rarityByLandType[4] = 2;
        ls.classGroupByLandType[4] = 2;
        ls.classByLandType[4] = 0;

        // landType 5 = common (heart)
        ls.rarityByLandType[5] = 3;
        ls.classGroupByLandType[5] = 0;
        ls.classByLandType[5] = 0;

        // landType 6 = common (cloud)
        ls.rarityByLandType[6] = 3;
        ls.classGroupByLandType[6] = 0;
        ls.classByLandType[6] = 2;

        // landType 7 = common (flower)
        ls.rarityByLandType[7] = 3;
        ls.classGroupByLandType[7] = 0;
        ls.classByLandType[7] = 3;

        // landType 8 = common (candy)
        ls.rarityByLandType[8] = 3;
        ls.classGroupByLandType[8] = 0;
        ls.classByLandType[8] = 4;

        // landType 9 = common (crystal)
        ls.rarityByLandType[9] = 3;
        ls.classGroupByLandType[9] = 0;
        ls.classByLandType[9] = 6;

        // landType 10 = common (moon)
        ls.rarityByLandType[10] = 3;
        ls.classGroupByLandType[10] = 0;
        ls.classByLandType[10] = 7;

        // landType 11 = Rainbow + the suffix (hidden)
        ls.rarityByLandType[11] = 3;
        ls.classGroupByLandType[11] = 0;
        ls.classByLandType[11] = 1;

        // landType 12 = Omnom + the suffix (hidden)
        ls.rarityByLandType[12] = 3;
        ls.classGroupByLandType[12] = 0;
        ls.classByLandType[12] = 5;

        // landType 13 = Star + the suffix (hidden)
        ls.rarityByLandType[13] = 3;
        ls.classGroupByLandType[13] = 0;
        ls.classByLandType[13] = 8;
    }
}
