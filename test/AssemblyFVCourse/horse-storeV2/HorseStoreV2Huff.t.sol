// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {console} from "forge-std/Test.sol";
import {HuffDeployer} from "@foundry-huff/HuffDeployer.sol";
import {BaseTestV2, HorseStore} from "./BaseTestV2.t.sol";

contract HorseStoreHuffV2 is BaseTestV2 {
    string public constant horseStoreLocation = "AssemblyFVCourse/horse-storeV2/HorseStore";

    function setUp() public override {
        horseStore = HorseStore(
            HuffDeployer.config().with_args(bytes.concat(abi.encode(NFT_NAME), abi.encode(NFT_SYMBOL))).deploy(
                horseStoreLocation
            )
        );
        vm.label(address(horseStore), "HorseStore");
        console.log("HorseStore deployed at address: ", address(horseStore));
    }
}