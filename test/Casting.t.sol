// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console2, console} from "forge-std/Test.sol";
import {sl} from "@solc-log/sl.sol";

/// Verifies casting behavior for various types
contract Casting is Test {
  
  /// forge test --mt testCastBytes -vv
  function testCastBytes() public {
    // Data with 4 bytes pattern containing index values
    console2.log("Original data");
    bytes32 data = 0xDEADBEE100000001DEADBEE200000002DEADBEE300000003DEADBEE400000004;

    console2.logBytes32(data);

    console2.log("Downcast bytes32 data to bytes4");
    bytes4 down = bytes4(data);     // get the most significant bytes and cut the rest
    console2.logBytes4(down);

    console2.log("Upcast bytes4 to bytes32");
    bytes32 upcast = bytes32(down); // place data in the most significant bytes and leave empty the rest
    console2.logBytes32(upcast);
  }

  /// Test behavior of casting 
  /// forge test --mt testCastUint -vv
  /// https://github.com/x676f64/secureum-mind_map/blob/master/quizzes/2.%20Solidity%20101.md#q26-conversions-in-solidity-have-the-following-behavior
  function testCastUint() public {
    // val = 1001111111110001
    uint16 val = 40945;
    sl.logAsBin("uint16 val: ", val);

    // downcasting needs explicit conversion
    // notice which bits were removed - higher order!
    uint8 smaller = uint8(val);
    
    sl.logAsBin("uint8: ", smaller);
    assertEq(smaller, 241);

    // upcasting can be implicit
    // adds bits on the left; (padding in higher order)
    uint16 bigger = smaller;
    sl.logAsBin("implicit upcast to uint16: ", bigger);
    console2.log("bigger as number:         ", bigger);
  }
}
