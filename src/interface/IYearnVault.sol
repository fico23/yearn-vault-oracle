// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

interface IYearnVault {
    function balanceOf(address) external view returns (uint256);
    function pricePerShare() external view returns (uint256);
}