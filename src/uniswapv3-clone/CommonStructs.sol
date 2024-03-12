// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

library Tick {
  struct Info {
    bool initialized;
    uint128 liquidity;
  }

  function update(mapping(int24 => Tick.Info) storage self, int24 tick, uint128 liquidityDelta) internal {
    Tick.Info storage tickInfo = self[tick];
    uint128 liquidityBefore = tickInfo.liquidity;
    uint128 liquidityAfter = liquidityBefore + liquidityDelta;

    if (liquidityBefore == 0) {
      tickInfo.initialized = true;
    }

    tickInfo.liquidity = liquidityAfter;
  }
}

library Position {
  struct Info {
    uint128 liquidity;
  }

  function get(
    mapping(bytes32 => Info) storage self,
    address owner,
    int24 lowerTick,
    int24 upperTick
  ) internal view returns (Position.Info storage position) {
    position = self[
      keccak256(abi.encodePacked(owner, lowerTick, upperTick))
    ];
  }

  function update(Info storage self, uint128 liqduidityDelta) internal {
    uint128 liquidityBefore = self.liquidity;
    uint128 liquidityAfter = liquidityBefore + liqduidityDelta;
    self.liquidity = liquidityAfter;
  }
}

library Errors {
  error InvalidTickRange();
  error InsufficientInputAmount();
  error ZeroLiquidity();
}