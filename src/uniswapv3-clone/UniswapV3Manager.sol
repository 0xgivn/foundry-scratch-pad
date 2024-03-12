// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniswapV3Pool.sol";
import "./callback/IUniswapV3MintCallback.sol";
import "./callback/IUniswapV3SwapCallback.sol";

contract UniswapV3Manager {
    function mint(
        address poolAddress_,
        int24 lowerTick,
        int24 upperTick,
        uint128 liquidity,
        bytes calldata data
    ) public {
        UniswapV3Pool(poolAddress_).mint(
            msg.sender,
            lowerTick,
            upperTick,
            liquidity,
            data
        );
    }

    function swap(address poolAddress_, bytes calldata data) public {
        UniswapV3Pool(poolAddress_).swap(msg.sender, data);
    }

    function uniswapV3MintCallback(
        uint256 amount0Owed,
        uint256 amount1Owed,
        bytes calldata data
    ) external {
      IUniswapV3Pool.CallbackData memory extra = abi.decode(data, (IUniswapV3Pool.CallbackData));
      IERC20(extra.token0).transfer(msg.sender, amount0Owed);
      IERC20(extra.token1).transfer(msg.sender, amount1Owed);
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external {
      IUniswapV3Pool.CallbackData memory extra = abi.decode(data, (IUniswapV3Pool.CallbackData));
      if (amount0Delta > 0) {
        IERC20(extra.token0).transferFrom(extra.payer, msg.sender, uint256(amount0Delta));
      }

      if (amount1Delta > 0) {
        IERC20(extra.token1).transferFrom(extra.payer, msg.sender, uint256(amount1Delta));
      }
    }
}
