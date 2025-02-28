// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "forge-std/Script.sol";

/*

Run from root folder:

forge script ./script/DeploySimpleContract.s.sol --tc DeploySimpleContract --broadcast --fork-url http://localhost:8545 --private-key 0x305c2b2709444f3ac649adca0fe6503eda409ed12afe72f11826a504676451e8  --code-size-limit 50000

*/
contract DeploySimpleContract is Script {
  function run() public {
   
    vm.startBroadcast();
    
    SimpleContract sc = new SimpleContract();

    vm.stopBroadcast();
  }
}

contract SimpleContract {
    uint256 public value = 123;

    function setValue(uint256 _value) external {  value = _value; }
}