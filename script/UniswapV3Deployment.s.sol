// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "@test/MockERC20.sol";
import "@src/uniswapv3-clone/UniswapV3Pool.sol";
import "@src/uniswapv3-clone/UniswapV3Manager.sol";

/*

Run from root folder:

forge script ./script/UniswapV3Deployment.s.sol --broadcast --fork-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  --code-size-limit 50000

*/
contract UniswapV3Deployment is Script {
  function run() public {
    uint256 wethBalance = 1 ether;
    uint256 usdcBalance = 5042 ether;
    int24 currentTick = 85176;
    uint160 currentSqrtP = 5602277097478614198912276234240;

    vm.startBroadcast();
    MockERC20 token0 = new MockERC20("Wrapped Ether", "WETH", 18);
    MockERC20 token1 = new MockERC20("USD Coin", "USDC", 18);

    UniswapV3Pool pool = new UniswapV3Pool(
      address(token0),
      address(token1),
      currentSqrtP,
      currentTick
    );

    UniswapV3Manager manager = new UniswapV3Manager();
    
    console.log("WETH address", address(token0));
    console.log("USDC address", address(token1));
    console.log("Pool address", address(pool));
    console.log("Manager address", address(manager));

    vm.stopBroadcast();
  }
}