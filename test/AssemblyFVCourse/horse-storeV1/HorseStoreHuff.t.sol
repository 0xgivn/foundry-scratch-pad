// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "./BaseTestV1.t.sol";
import "@horse-storeV1/HorseStore.sol";
import "@foundry-huff/HuffDeployer.sol";

contract HorseStoreHuff is BaseTestV1 {
  // no need to specify src prefix or .huff extension
  string public constant HORSE_STORE_LOCATION = "AssemblyFVCourse/horse-storeV1/HorseStore";

  function setUp() public override {
    horseStore = HorseStore(HuffDeployer.config().deploy(HORSE_STORE_LOCATION));
  }
}