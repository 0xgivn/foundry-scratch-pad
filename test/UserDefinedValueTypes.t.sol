// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {sl} from "@solc-log/sl.sol";

// ============ Work in Progress, needs better real-world examples ================

// Examples for user defined value types and how to use them to prevent common mistakes.
// Strict type definitions prevent hard to catch bugs by making it impossible to mix up parameter values.
//
// In the following test demonstrates how unsafe code can run without any indications of something going wrong
// and how it can be refactored to prevent issues at compile time.
// Solidity docs: https://soliditylang.org/blog/2021/09/27/user-defined-value-types/
contract UserDefinedValueTypes is Test {
  type Gross is int256;

  function testUnsafeCalculateNetValue() public pure {
    int256 grossValue = 10 ether;
    int256 tax = 0.3 ether;
    sl.logLineDelimiter("Unsafe calculate net value");
    sl.logInt("Correct net value: ", calculateNetValue(grossValue, tax));
    sl.logInt("Wrong net value: ", calculateNetValue(tax, grossValue));
  }

  function testCalculateNetValueSafe() public pure {
    Gross grossValue = Gross.wrap(10 ether);
    int256 tax = 0.3 ether;

    sl.logLineDelimiter("Safe calculate net value");
    sl.logInt("Correct net value: ", calculateNetValueSafe(grossValue, tax));
    sl.log("Wrong function call doesn't compile nor execute.");

    // This line doesn't compile because the compiler catches the mistake
    // sl.logInt("Wrong net value: ", calculateNetValueSafe(tax, grossValue));
  }

  // Unsafe version of calculate net value
  function calculateNetValue(int256 grossValue, int256 taxPercentageWAD) public pure returns (int256 netValue) {
    int256 taxedAmount = grossValue * taxPercentageWAD / 1 ether;
    netValue = grossValue - taxedAmount;
  }

  // Safe version of calculate net value
  function calculateNetValueSafe(Gross grossValue, int256 taxPercentageWAD) public pure returns (int256 netValue) {
    // require(taxPercentageWAD <= 1 ether); ---> run-time check - costlier than compile-time one, which we get for free
    int256 taxedAmount = Gross.unwrap(grossValue) * taxPercentageWAD / 1 ether;
    netValue = Gross.unwrap(grossValue) - taxedAmount;
  }
  
  //// Not good example, because operation is commutative - WIP

  // function testUnsafeExchangeRate() public pure {
  //   uint256 tokens = 10 ether;
  //   uint256 exchangeRate = 1.3 ether;

  //   sl.log("Correct exchange rate: ", calculateTokenExchange(tokens, exchangeRate));
  //   sl.log("Wrong exchange rate: ", calculateTokenExchange(exchangeRate, tokens));
  // }

  // function calculateTokenExchange(uint256 amountIn, uint256 exchangeRate) public pure returns (uint256 amountOut) {
  //   // Exchange rate = amountOut / amountIn
  //   amountOut = (amountIn * exchangeRate) / 1e18; // Assuming exchangeRate is scaled by 1e18
  // }

}