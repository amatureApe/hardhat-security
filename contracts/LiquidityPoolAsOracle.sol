//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This contract uses a liquidity pool as an oracle

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LiquidityPoolAsOracle {
    address public s_token1;
    address public s_token2;

    constructor(address token1, address token2) {
        require(token1 != address(0x0), "Address cannot be 0");
        require(token2 != address(0x0), "Address cannot be 0");
        s_token1 = token1;
        s_token2 = token2;
    }

    function swap(
        address from,
        address to,
        uint256 amount
    ) external {
        require(
            (from == s_token1 && to == s_token2) ||
                (from == s_token2 && to == s_token1),
            "Invalid tokens"
        );
        require(
            IERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough to swap"
        );
        uint256 swap_amount = getSwapPrice(from, to, amount);
        bool txFromSuccess = IERC20(from).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(txFromSuccess, "Failed to transfer from");
    }

    function addLiquidity(address tokenAddress, uint256 amount) external {
        bool success = IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(success, "Failed to add liquidity");
    }

    function getSwapPrice(
        address from,
        address to,
        uint256 amount
    ) public view returns (uint256) {
        return ((amount * IERC20(to).balanceOf(address(this))) /
            IERC20(from).balanceOf(address(this)));
    }
}
