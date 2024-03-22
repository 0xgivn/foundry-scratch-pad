// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "@horse-storeV1/HorseStore.sol";

// Contract containing actual tests
// Child contracts instantiate solc or huff version of the contract
// forge test --mc HorseStore -- runs both solc and huff tests
// forge test --mc HorseStoreHuff -- runs only huff
// forge test --mc HorseStoreHuff --debug testWriteValue -- runs in debug mode
abstract contract BaseTestV1 is Test {
  
  HorseStore public horseStore;

  function setUp() virtual public {
    
  }
  function testReadValue() public {
    uint256 value = horseStore.readNumberOfHorses();
    assertEq(value, 0);
  }

  function testWriteValue(uint256 numberOfHorses) public {
    horseStore.updateHorseNumber(numberOfHorses);
    assertEq(horseStore.readNumberOfHorses(), numberOfHorses);
  }
}