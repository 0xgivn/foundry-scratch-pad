// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "./BaseTestV1.t.sol";
import "@horse-storeV1/HorseStore.sol";

contract HorseStoreSolc is BaseTestV1 {
  function setUp() public override {
    horseStore = new HorseStore();
  }
}