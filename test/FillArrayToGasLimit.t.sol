// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console2} from "forge-std/Test.sol";
import {sl} from "@solc-log/sl.sol";

struct Entry {
  bytes32 valueA;
  uint256 valueB;
}

/// The block.gaslimit at the time of writing is 30_000_000
/// Check the current value here: https://ycharts.com/indicators/ethereum_average_gas_limit
contract FillArrayToGasLimit is Test {
  Entry[] public entries;

  constructor() {
    entries.push(Entry(0x0, 0));
  }

  /// The test will end when gasLimit is reached
  /// Filling up an array with entries is not a problem by itself.
  /// An issue would occur if the array has to be iterated over.
  function testFillArrayToGasLimit() public {
    uint256 startingGas = gasleft();
    uint256 gasLimit = 30_000_000; // block.gaslimit; - https://ycharts.com/indicators/ethereum_average_gas_limit
    sl.log("block.gaslimit: ", gasLimit);
    sl.log("startingGas: ", startingGas);
    while(true) {
      entries.push(Entry(0x0, entries.length));
      if (entries.length > 1150) {
        sl.log("gasleft: ", gasleft()); // the delta between each array.push is stable >>> big array pushes don't consume more gas
      }

      if (startingGas - gasleft() > gasLimit) {
        sl.log("entries.length: ", entries.length);
        break;
      }
    }
  }
}