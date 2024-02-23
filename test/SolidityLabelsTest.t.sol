// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";

import "@src/SolidityLabels.sol";

contract SolidityLabelsTest is Test {
  NoLabels noLabels;
  WithLabels withLabels;

  function setUp() public {
    noLabels = new NoLabels();
    withLabels = new WithLabels();
  }

  function testCheckGasNoLabels() public {
    for (uint256 i; i < 1_000_000; ++i) {
      noLabels.setNumber(i);
    }
  }

  function testCheckGaWithLabels() public {
    for (uint256 i; i < 1_000_000; ++i) {
      withLabels.setNumber(i);
    }
  }
}