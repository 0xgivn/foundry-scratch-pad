// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {sl} from "@solc-log/sl.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

// Logs examples of calculations with various decimal places.
contract CalculateOraclePrices is Test {
  using FixedPointMathLib for uint;

  function testLogDifferentLiteralsFor1Ether() public pure {
    sl.log("1e18    : ", 1e18);
    sl.log("1 ether : ", 1 ether);
    sl.log("10**18  : ", 10**18);
  }

  function testCalculateETHValueInUSDFromOraclePrice() public pure {
    uint256 asset = 15 ether;
    uint256 assetDecimals = 18;
    uint256 price = 2975_400_000; // price with 6 decimals $2,975.40
    uint256 oracleDecimals = 6;
    
    uint256 usdValue = asset * price * 1e18 / 10**oracleDecimals / 10**assetDecimals;
    // equation: 44631 = 15 * 2975,4
    sl.log("usdValue of ETH is: ", usdValue);
  }

  function testCalculateSTETHwithChainlinkOracle() public pure {
    //https://etherscan.io/address/0xCfE54B5cD566aB89272946F602D76Ea879CAb4a8#readContract - 
    uint256 stETH = 15 ether;
    uint256 stETHDecimals = 18;
    uint256 price = 297_183_734_925; // price with 8 decimals $2,971.84
    uint256 oracleDecimals = 8;
    
    // uint256 usdValue = stETH * price * 1e18 / 10**oracleDecimals / 10**stETHDecimals;
    sl.log("stETH amount: ", stETH);
    sl.log("oracle price: ", price, 8);

    uint256 priceMulStETH = price * stETH; // 18 + 8 = 26 decimals
    sl.log("stETH * price: ", priceMulStETH);

    uint256 incrDecimals = priceMulStETH * 1e18; // 26 + 18 = 44 decimals
    sl.log("stETH * price * 1e18: ", incrDecimals);

    uint256 adjustForOracleDecimals = incrDecimals / 10**oracleDecimals; // 44 - 8 = 36 decimals
    sl.log("stETH * price * 1e18 / 10**oracleDecimals: ", adjustForOracleDecimals);

    uint256 adjustForSTETHDecimals = adjustForOracleDecimals / 10**stETHDecimals; // 36 - 18 = 18 decimals
    sl.log("stETH * price * 1e18 / 10**oracleDecimals / 10**stETHDecimals: ", adjustForSTETHDecimals);


    uint256 usdValue = adjustForSTETHDecimals;
    sl.log("usdValue of stETH is: ", usdValue);

  }

}