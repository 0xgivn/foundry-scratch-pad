// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console2, console} from "forge-std/Test.sol";

/// Test contract to verify the priority of operators
/// Inspiration - https://github.com/x676f64/secureum-mind_map/blob/master/quizzes/2.%20Solidity%20101.md#q24-if-a--1-then-which-of-the-following-isare-true
contract OperatorPriorityTest is Test {
  
  function testOperatorPriority() public {
    uint256 a = 1;

    a += 1;
    assertEq(a, 2);
    
    // assignment has higher priority than postfix --
    uint256 b = a--;
    assertEq(b, 2);
    assertEq(a, 1);

    // prefix ++ has higher priority than assignment
    b = ++a;
    assertEq(b, 2);
    assertEq(a, 2);
  }
}
