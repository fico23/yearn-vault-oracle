// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/YearnVaultOracle.sol";

contract YearnVaultOracleTest is Test {
    YearnVaultOracle public yearnVaultOracle;

    function setUp() public {
        yearnVaultOracle = new YearnVaultOracle();
    }
}
