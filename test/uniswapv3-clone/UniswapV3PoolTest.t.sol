// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "@test/MockERC20.sol";
import "@src/uniswapv3-clone/UniswapV3Pool.sol";
import "@src/uniswapv3-clone/IUniswapV3Pool.sol";
import "@src/uniswapv3-clone/callback/IUniswapV3MintCallback.sol";
import "@src/uniswapv3-clone/callback/IUniswapV3SwapCallback.sol";

contract UniswapV3PoolTest is Test, IUniswapV3MintCallback, IUniswapV3SwapCallback {

    MockERC20 token0;
    MockERC20 token1;
    UniswapV3Pool pool;
    bool transferInMintCallback;
    bool transferInSwapCallback;

    function setUp() public {
      token0 = new MockERC20("Ether", "ETH", 18);
      token1 = new MockERC20("USDC", "USDC", 18);
    }

    struct TestCaseParams {
      uint256 wethBalance;
      uint256 usdcBalance;
      int24 currentTick;
      int24 lowerTick;
      int24 upperTick;
      uint128 liquidity;
      uint128 currentSqrtP;
      bool shouldTransferInCallback;
      bool mintLiqudity;
    }

    function testMintSuccess() public {
      TestCaseParams memory params = TestCaseParams({
        wethBalance: 1 ether,
        usdcBalance: 5000 ether,
        currentTick: 85176,
        lowerTick: 84222,
        upperTick: 86129,
        liquidity: 1517882343751509868544,
        currentSqrtP: 5602277097478614198912276234240,
        shouldTransferInCallback: true,
        mintLiqudity: true
      });

      (uint256 poolBalance0, uint256 poolBalance1) = setupTestCase(params);
      uint256 expectedAmount0 = 0.998976618347425280 ether;
      uint256 expectedAmount1 = 5000 ether;
      assertEq(poolBalance0, expectedAmount0, "incorrect token0 deposited amount");
      assertEq(poolBalance1, expectedAmount1, "incorrect token1 deposited amount");

      assertEq(token0.balanceOf(address(pool)), expectedAmount0);
      assertEq(token1.balanceOf(address(pool)), expectedAmount1);

      bytes32 positionKey = keccak256(
        abi.encodePacked(address(this), params.lowerTick, params.upperTick)
      );

      uint128 posLiquidity = pool.positions(positionKey); // only using first value of deconstructed struct
      assertEq(posLiquidity, params.liquidity);

      (bool tickInitialized, uint128 tickLiquidity) = pool.ticks(params.lowerTick);
      assertTrue(tickInitialized);
      assertEq(tickLiquidity, params.liquidity);

      (tickInitialized, tickLiquidity) = pool.ticks(params.upperTick);
      assertTrue(tickInitialized);
      assertEq(tickLiquidity, params.liquidity);

      (uint160 sqrtPriceX96, int24 tick) = pool.slot0();
      assertEq(sqrtPriceX96, 5602277097478614198912276234240, "invalid current sqrtP");
      assertEq(tick, 85176, "invalid current tick");
      assertEq(pool.liquidity(), 1517882343751509868544, "invalid current liquidity");
    }

    function testSwapBuyEth() public {
      TestCaseParams memory params = TestCaseParams({
        wethBalance: 1 ether,
        usdcBalance: 5000 ether,
        currentTick: 85176,
        lowerTick: 84222,
        upperTick: 86129,
        liquidity: 1517882343751509868544,
        currentSqrtP: 5602277097478614198912276234240,
        shouldTransferInCallback: true,
        mintLiqudity: true
      });

      (uint256 poolBalance0, uint256 poolBalance1) = setupTestCase(params);
      
      uint256 swapAmount = 42 ether;
      token1.mint(address(this), swapAmount);
      token1.approve(address(this), swapAmount);
      int256 userBalance0Before = int256(token0.balanceOf(address(this)));

      transferInSwapCallback = true;

      (int256 amount0Delta, int256 amount1Delta) = pool.swap(
        address(this),
        abi.encode(token0, token1, address(this))
      );
      assertEq(amount0Delta, -0.008396714242162444 ether, "invalid ETH out");
      assertEq(amount1Delta, 42 ether, "invalid USDC in");
      assertEq(token0.balanceOf(address(this)), uint256(userBalance0Before - amount0Delta), "invalid user ETH balance");
      assertEq(token1.balanceOf(address(this)), 0, "invalid user USDC balance");
    }

    function setupTestCase(TestCaseParams memory params) internal 
    returns (uint256 poolBalance0, uint256 poolBalance1) {
      token0.mint(address(this), params.wethBalance);
      token1.mint(address(this), params.usdcBalance);

      pool = new UniswapV3Pool(
        address(token0),
        address(token1),
        params.currentSqrtP,
        params.currentTick
      );

      transferInMintCallback = params.shouldTransferInCallback;
      
      if (params.mintLiqudity) {
        token0.approve(address(this), params.wethBalance);
        token1.approve(address(this), params.usdcBalance);

        (poolBalance0, poolBalance1) = pool.mint(
          address(this),
          params.lowerTick,
          params.upperTick,
          params.liquidity,
          abi.encode(token0, token1, address(this))
        );
      }      
    }

    function uniswapV3MintCallback(
        uint256 amount0Owed,
        uint256 amount1Owed,
        bytes calldata data
    ) external {
      if (transferInMintCallback) {
        IUniswapV3Pool.CallbackData memory extra = abi.decode(data, (IUniswapV3Pool.CallbackData));
        IERC20(extra.token0).transfer(msg.sender, amount0Owed);
        IERC20(extra.token1).transfer(msg.sender, amount1Owed);
      }
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external {
      if(!transferInSwapCallback) {
        return;
      }

      IUniswapV3Pool.CallbackData memory extra = abi.decode(data, (IUniswapV3Pool.CallbackData));
      if (amount0Delta > 0) {
        IERC20(extra.token0).transferFrom(extra.payer, msg.sender, uint256(amount0Delta));
      }

      if (amount1Delta > 0) {
        IERC20(extra.token1).transferFrom(extra.payer, msg.sender, uint256(amount1Delta));
      }
    }
}