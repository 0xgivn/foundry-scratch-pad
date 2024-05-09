// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {sl} from "@solc-log/sl.sol";

interface ISomeInterface {
  function tokenA() external view returns (address);
  function tokenB() external view returns (address);
}

contract DeFiAdapter is ISomeInterface {
  function tokenA() external view override returns (address) {
    return address(0x1111111111111111111111111111111111111111);
  }

  function tokenB() external view override returns (address) {
    return address(0x2222222222222222222222222222222222222222);
  }
}

// Examples for encoding a variable to bytes and then decoding it back to a different type
contract BytesAbiEncodeDecode is Test {
  function testEncodeDecodeBytes() public {
    Helper helper = new Helper();
    bytes memory data;
    
    sl.logLineDelimiter("When data is \"\"");
    logBytesContents(data);

    try helper.decodeDataAsAddress(data) returns (address decoded) {
      sl.log("Decoded \"\" to address: ", decoded); // Decoding fails, this won't print
    } catch {  }
    
    try helper.decodeDataAsInterface(data) returns (ISomeInterface decoded) {
      sl.log("Decoded data to ISomeInterface"); // Decoding fails, this won't print
      sl.log("tokenA: ", decoded.tokenA());
      sl.log("tokenB: ", decoded.tokenB());
    } catch {  }

    try helper.decodeDataAsUint256(data) returns (uint256 decoded) {
      sl.log("Decoded \"\" to uint256: ", decoded); // Decoding fails, this won't print
    } catch {  }



    uint256 aNumber = 1234567;
    data = abi.encode(aNumber);

    sl.logLineDelimiter("When data is uint256(1234567)");
    logBytesContents(data);

    try helper.decodeDataAsAddress(data) returns (address decoded) {
      sl.log("Decoded data to address: ", decoded);
    } catch {  }
    
    try helper.decodeDataAsInterface(data) returns (ISomeInterface decoded) {
      sl.log("Decoded data to ISomeInterface"); // Decoding uint256 to ISomeInterface succeeds
      sl.log("ISomeInterface address: ", address(decoded));
      // sl.log("tokenA: ", decoded.tokenA());  // These calls will fail
      // sl.log("tokenB: ", decoded.tokenB());
    } catch {  }

    try helper.decodeDataAsUint256(data) returns (uint256 decoded) {
      sl.log("Decoded data to uint256: ", decoded, 0); // Success (as expected for uint256)
    } catch {  }




    address anAddress = makeAddr("random-address");
    data = abi.encode(anAddress);

    sl.logLineDelimiter("When data is address");
    logBytesContents(data);

    try helper.decodeDataAsAddress(data) returns (address decoded) {
      sl.log("Decoded data to address: ", decoded);
    } catch {  }
    
    try helper.decodeDataAsInterface(data) returns (ISomeInterface decoded) {
      sl.log("Decoded data to ISomeInterface"); // Decoding uint256 to ISomeInterface succeeds
      sl.log("ISomeInterface address: ", address(decoded));
      // sl.log("tokenA: ", decoded.tokenA());  // These calls will fail
      // sl.log("tokenB: ", decoded.tokenB());
    } catch {  }

    try helper.decodeDataAsUint256(data) returns (uint256 decoded) {
      sl.log("Decoded data to uint256: ", decoded, 0); // Success
    } catch {  }



    DeFiAdapter someContract = new DeFiAdapter();
    data = abi.encode(someContract);
    sl.logLineDelimiter("When data is contract - abi.encode(someContract)");
    logBytesContents(data);

    try helper.decodeDataAsAddress(data) returns (address decoded) {
      sl.log("Decoded data to address: ", decoded);
    } catch {  }
    
    try helper.decodeDataAsInterface(data) returns (ISomeInterface decoded) {
      sl.log("Decoded data to ISomeInterface"); // Decoding uint256 to ISomeInterface succeeds
      sl.log("ISomeInterface address: ", address(decoded));
      sl.log("tokenA: ", decoded.tokenA());  // These calls now succeed
      sl.log("tokenB: ", decoded.tokenB());
    } catch {  }

    try helper.decodeDataAsUint256(data) returns (uint256 decoded) {
      sl.log("Decoded data to uint256: ", decoded, 0); 
    } catch {  }
  }

  function testEncodeDecodeBytesTuple() public {
    Helper helper = new Helper();
    bytes memory data = abi.encode(uint128(1234567), makeAddr("random-address"));
    sl.logLineDelimiter("When data abi.encode(uint128, address)");
    logBytesContents(data);

    try helper.decodeDataAsAddress(data) returns (address decoded) {
      sl.log("Decoded data to address: ", decoded);
    } catch {  }
    
    try helper.decodeDataAsInterface(data) returns (ISomeInterface decoded) {
      sl.log("Decoded data to ISomeInterface"); // Decoding uint256 to ISomeInterface succeeds
      sl.log("ISomeInterface address: ", address(decoded));
      // sl.log("tokenA: ", decoded.tokenA());  // These calls fail
      // sl.log("tokenB: ", decoded.tokenB());
    } catch {  }

    try helper.decodeDataAsUint256(data) returns (uint256 decoded) {
      sl.log("Decoded data to uint256: ", decoded, 0); 
    } catch {  }

    try helper.decodeDataAsUint128AddressTuple(data) returns (uint128 decoded1, address decoded2) {
      sl.log("Decoded (uint128, address) tuple");
      sl.log("first element: ", decoded1, 0); // correct
      sl.log("second element: ", decoded2);   // correct
    } catch {  }
  }

  function logBytesContents(bytes memory data) public {
    sl.log("Printing data contents, with length: ", data.length, 0);
    console2.logBytes(data);
  }

}

// Using external contract enables try/catch syntax
contract Helper {
  function decodeDataAsAddress(bytes memory data) external pure returns (address) {
    return abi.decode(data, (address));
  }

  function decodeDataAsInterface(bytes memory data) external pure returns (ISomeInterface) {
    return abi.decode(data, (ISomeInterface));
  }

  function decodeDataAsUint256(bytes memory data) external pure returns (uint256) {
    return abi.decode(data, (uint256));
  }

  function decodeDataAsUint128AddressTuple(bytes memory data) external pure returns (uint128, address) {
    return abi.decode(data, (uint128, address));
  }
}