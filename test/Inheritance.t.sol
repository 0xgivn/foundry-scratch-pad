// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console2, console} from "forge-std/Test.sol";
import {sl} from "@solc-log/sl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


/// Test file to verify certain inheritance topics
/// Inspiration - https://github.com/x676f64/secureum-mind_map/blob/master/quizzes/3.%20Solidity%20201.md#q25-which-of-the-following-isare-not-allowed

// function override, overload, modifier override and overload
contract Base {
  address owner;
  uint256 counter;

  constructor() {
    owner = msg.sender;
  }

  function increment() onlyOwner virtual public {
    counter++;
  }

  modifier onlyOwner virtual {
    require(msg.sender == owner, "only owner can call this fn");
    _;
  }

  // overload is forbidden - Error (2333): Identifier already declared.
  // modifier onlyOwner(address) { 
  //   require(msg.sender == owner, "only owner can call this fn");
  //   _;
  // }
}

contract Derive is Base {
  using Strings for uint256;

  string public status;

  function increment() override public { // override allowed
    super.increment();
    status = string.concat("counter changed to ", counter.toString());
  }

  function increment(uint256 number) public { // overload allowed
    super.increment();
    counter = number;
    status = string.concat("counter changed to ", counter.toString());
  }

  // override for modifier is allowed
  modifier onlyOwner override {
    _;
  }
}

contract InheritanceTest is Test {
  
}
