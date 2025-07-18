// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console2, console} from "forge-std/Test.sol";
import {sl} from "@solc-log/sl.sol";

/// Exploring Solidity Literals
contract Literals is Test {
  
  /// forge test --mt testUintLiterals -vv
  function testUintLiterals() public {
    uint256 wad = 1e18;
    console2.log("WAD:    ", wad);
    console2.log("1 ether:", uint256(1 ether));

    // Fixed decimal point literal
    uint256 eNum = 0.0001e8;
    console2.log("eNum:   ", eNum);
  }

}
