// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";

contract DeFiContract {
  uint256 value = 7;
  function noStateChange() public view returns (uint256) {
    return value;
  }

  function stateChange() public returns (uint256) {
    value = 8;
    return value;
  }
}

contract StaticCallRevert is Test {
  
  // This test shows what happens with the gas upon function static call 
  // 1st case is normal usage of static call - no state changes
  // 2nd case is when the static call makes a state change and reverts
  function testStaticCallRevertGas() public {
    DeFiContract defiContract = new DeFiContract();
    uint256 gas = gasleft();
    console2.log("Gas left before static call: ", gas);

    // Example 1: Normal use case of static call to a function that doesn't change state
    bytes memory fnCall = abi.encodeWithSelector(DeFiContract.noStateChange.selector);
    (bool success, bytes memory data) = address(defiContract).staticcall(fnCall);
    assertTrue(success);
    assertEq(data.length, 32);
    uint256 result;
    assembly {
      result := mload(add(data, 32))
    }
    console2.log("Result of noStateChange: ", result);
    console2.log("Gas left after noStateChange static call: ", gasleft());

    
    // Example 2: Use case of static call to a function that changes state
    fnCall = abi.encodeWithSelector(DeFiContract.stateChange.selector);
    (success, data) = address(defiContract).staticcall(fnCall);
    console2.log("stateChange static call success: ", success);
    // 1/64 th of the gas is left, all else is consumed
    console2.log("Gas left after stateChange static call: ", gasleft());

    
    // Example 3: Static call to an invalid address
    (success, data) = address(makeAddr("someAddress")).staticcall(fnCall);
    console2.log("Invalid address static call success: ", success);
    console2.logBytes(data);
    console2.log("Gas left after invalid address static call: ", gasleft()); // normal gas consumption
  }
}
