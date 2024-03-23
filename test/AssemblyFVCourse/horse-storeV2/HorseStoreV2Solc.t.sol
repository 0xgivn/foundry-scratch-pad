// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {console} from "forge-std/Test.sol";
import {BaseTestV2} from "./BaseTestV2.t.sol";
import {HorseStore} from "@src/AssemblyFVCourse/horse-storeV2/HorseStore.sol";

contract HorseStoreSolidityV2 is BaseTestV2 {
  function setUp() public virtual override {
    horseStore = new HorseStore();
    vm.label(address(horseStore), "HorseStore");
    console.log("HorseStore deployed at address: ", address(horseStore));
  }
}