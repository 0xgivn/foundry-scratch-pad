// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console2, console} from "forge-std/Test.sol";


/// Deploying contract from bytecode


contract SimpleContract {
    uint256 public value = 123;

    function setValue(uint256 _value) external {  value = _value; }
}


contract CFactory {
    function createContract(bytes memory bytecode) external returns (address newContract) {
        require(bytecode.length != 0, "Bytecode cannot be empty");

        assembly {
            newContract := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(newContract != address(0), "Contract creation failed");
    }
}

contract DeployBytecodeContract is Test {  

  bytes simpleContractBytecode = hex"6080604052607b5f553480156012575f5ffd5b5060aa80601e5f395ff3fe6080604052348015600e575f5ffd5b50600436106030575f3560e01c80633fa4f2451460345780635524107714604d575b5f5ffd5b603b5f5481565b60405190815260200160405180910390f35b605c6058366004605e565b5f55565b005b5f60208284031215606d575f5ffd5b503591905056fea2646970667358221220638fa7edccdf88b2e21e3cad41a495ef4d97a409e632b6f21d5292c64ef74efb64736f6c634300081c0033";

  function setUp() public {
  }

  function testDeployFromBytecode() public {
    CFactory factory = new CFactory();
    address deployed = factory.createContract(simpleContractBytecode);
    SimpleContract sc = SimpleContract(deployed);
    assertEq(sc.value(), uint256(123));
  }

  function testEncodeFunctionCalls() public {
    bytes memory encodedCall = abi.encodeWithSignature("createContract(bytes)", simpleContractBytecode);
    console.log("encoded create contract call: ");
    console.logBytes(encodedCall);

    encodedCall = abi.encodeWithSignature("value()");
    console.log("encoded value call: ");
    console.logBytes(encodedCall);
  }

}
