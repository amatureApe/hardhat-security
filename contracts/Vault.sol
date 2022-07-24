//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// All data can be read on-chain in this contract

contract Vault {
    bool public s_locked;
    bytes32 private s_password;

    constructor(bytes32 password) {
        s_locked = true;
        s_password = password;
    }

    function unlock(bytes32 password) external {
        if (s_password == password) {
            s_locked = false;
        }
    }
}
