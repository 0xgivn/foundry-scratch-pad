// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console2, console} from "forge-std/Test.sol";
import {mulDiv18} from "@prb-math/Common.sol";


contract PrbMath is Test {

  /// @notice Fuzz test aims to find the limit in mulDiv18 (x*y÷1e18)
  /// under which precision loss starts to occur.
  function testForPrecisionLoss(uint88 amount, uint80 price) public {

    // @dev seems that only dust amounts can cause precision loss

    // amount = uint88(bound(amount, 1e8, 0.5 ether));
    amount = uint88(bound(amount, 1 ether, 15_000 ether));

    price = uint80(bound(price, 1e5, 1 ether));

    if (mulDiv18(amount, price) == 0) {
      console2.log("amount", amount);
      console2.log("price", price);
      fail("Amount x price is 0");
    }
  }
}