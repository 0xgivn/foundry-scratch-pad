// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

contract NoLabels {
  mapping(uint256 => address) idCounter;

  constructor() {}

  function setNumber(uint256 id) external {
    _setNumer(id, msg.sender);
  }

  function _setNumer(uint256 id, address user) private {
    idCounter[id] = user;
  }
}

contract WithLabels {
  mapping(uint256 id => address user) idCounter;

  constructor() {}

  function setNumber(uint256 id) external {
    _setNumer({id: id, user: msg.sender});
  }

  function _setNumer(uint256 id, address user) private {
    idCounter[id] = user;
  }
}