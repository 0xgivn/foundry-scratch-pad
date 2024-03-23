// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "./BaseTestV1.t.sol";
import "@horse-storeV1/HorseStoreYul.sol";
import "@horse-storeV1/IHorseStore.sol";

contract HorseStoreYulTest is BaseTestV1 {
  function setUp() public override {
    horseStore = new HorseStoreYul();
  }
}