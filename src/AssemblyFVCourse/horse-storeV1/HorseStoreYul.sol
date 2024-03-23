// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.23;

import "./IHorseStore.sol";

contract HorseStoreYul is IHorseStore {
    uint256 numberOfHorses;

    function updateHorseNumber(uint256 newNumberOfHorses) external {
        assembly {
          sstore(numberOfHorses.slot, newNumberOfHorses)
        }
    }

    function readNumberOfHorses() external view returns (uint256) {
        assembly {
          let num := sload(numberOfHorses.slot)
          mstore(0x00, num)
          return(0x00, 0x20)
        }
    }
}