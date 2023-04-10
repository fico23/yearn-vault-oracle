// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

interface ITriCrypto {
    function get_virtual_price() external view returns (uint256);
    function balances(uint256) external view returns (uint256);
    function token() external view returns (address);
}
