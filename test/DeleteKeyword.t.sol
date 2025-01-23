// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console2, console} from "forge-std/Test.sol";

struct Entry {
  uint256 id;
  address owner;
  bool occupied;
}

/// Test to verify the behavior of the delete keyword
/// on value and reference types
/// Inspiration - https://github.com/x676f64/secureum-mind_map/blob/master/quizzes/2.%20Solidity%20101.md#q25-delete-varname-has-which-of-the-following-effects
/// the answer in the quizz is partially correct, because struct values are reset when deleted, as proven by the test
contract DeleteKeywordTest is Test {  
  Entry storageEntry;
  uint256 simpleValue;
  string name;
  uint256[] indices;
  mapping(uint256 => address) indexToOwner;

  function setUp() public {
    storageEntry = Entry(
      1,
      address(1234),
      true
    );

    simpleValue = 7777;
    name = "hello_world";
    indices = [1, 2, 3];
    indexToOwner[1] = address(1);
    indexToOwner[2] = address(2);
    indexToOwner[3] = address(3);
  }

  function testDeleteKeywordValueTypes() public {
    // value types can only be allocated on the stack
    uint256 stackValue = 4444;

    assertEq(stackValue, 4444);
    assertEq(simpleValue, 7777);

    delete simpleValue;
    delete stackValue;

    assertEq(stackValue, 0);
    assertEq(simpleValue, 0);
  }

  function testDeleteKeywordStruct() public {
    Entry memory memoryEntry = Entry(
      2,
      address(9876),
      true
    );

    // assert entries are existing
    assertEq(storageEntry.id, 1);
    assertEq(storageEntry.owner, address(1234));
    assertEq(storageEntry.occupied, true);

    assertEq(memoryEntry.id, 2);
    assertEq(memoryEntry.owner, address(9876));
    assertEq(memoryEntry.occupied, true);

    // delete
    delete storageEntry;
    delete memoryEntry;

    assertEq(storageEntry.id, 0);
    assertEq(storageEntry.owner, address(0));
    assertEq(storageEntry.occupied, false);

    assertEq(memoryEntry.id, 0);
    assertEq(memoryEntry.owner, address(0));
    assertEq(memoryEntry.occupied, false);
  }

  function testDeleteMapping() public {
    // assert mapping has values
    assertEq(indexToOwner[1], address(1));
    assertEq(indexToOwner[2], address(2));
    assertEq(indexToOwner[3], address(3));

    // Built-in unary operator delete cannot be applied to type mapping
    // delete indexToOwner;
    delete indexToOwner[1];
    delete indexToOwner[2];
    delete indexToOwner[3];

    assertEq(indexToOwner[1], address(0));
    assertEq(indexToOwner[2], address(0));
    assertEq(indexToOwner[3], address(0));    
  }

  function testDeleteArray() public {
    uint256[] memory memArray = new uint256[](3);
    memArray[0] = 5;
    memArray[1] = 6;
    memArray[2] = 7;

    // strings are an array
    string memory memString = "fooo";

    // assert initial values
    assertEq(memArray[0], 5);
    assertEq(memArray[1], 6);
    assertEq(memArray[2], 7);
    assertEq(memString, "fooo");
    assertEq(indices[0], 1);
    assertEq(indices[1], 2);
    assertEq(indices[2], 3);
    
    delete memArray;
    delete memString;
    delete indices;

    // array out of bounds, no indices
    // assertEq(memArray[0], 5);
    assertEq(memArray.length, 0);

    assertEq(memString, "");

    // array out of bounds, no indices
    // assertEq(indices[0], 1);
    assertEq(indices.length, 0);
  }
}
