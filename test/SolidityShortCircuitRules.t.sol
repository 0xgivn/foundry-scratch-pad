// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console2, console} from "forge-std/Test.sol";
import {sl} from "@solc-log/sl.sol";

/// This test is inspired by discussions around how exactly are truth conditions
/// evaluated in statements like `if (f1() || f2())`
///
/// Docs on the topic:
/// https://docs.soliditylang.org/en/latest/types.html#booleans
/// The operators || and && apply the common short-circuiting rules. This means that in the 
/// expression f(x) || g(y), if f(x) evaluates to true, g(y) will not be evaluated even if it
/// may have side-effects.
contract SolidityShortCircuitRules is Test {

  uint256 someState;
  
  /// forge test --mt testEvaluateOrs -vv
  function testEvaluateOrs() public {
    bool isTrue = true;
    bool isFalse = false;

    if(isFalse || isTrue) {
      console.log(unicode"When either of || values is true, if succeeds ✅");
    } else {
      fail();
    }

    if(returnValue(false) || returnValue(true)) {
      console.log(unicode"When either of || funcs is true, if succeeds ✅");
    } else {
      fail();
    }

    if(returnValue(true) || revertFn(false)) {
      console.log(unicode"When first condition is true, the next is not evaluated ✅");
    } else {
      fail();
    }
  }

  function returnValue(bool value) internal returns (bool) {
    ++someState;
    return value;
  }

  function revertFn(bool value) internal returns (bool) {
    require(false, "This function reverts");
    ++someState;
    return value;
  }
}
